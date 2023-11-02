//
//  RecordTestPageController.swift
//  K-TALK-iOS
//
//  Created by JungGue LEE on 2023/10/30.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire

class RecordTestPageController : UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    var player : AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func RecordButton(_ sender: Any) {
        if audioRecorder == nil {
                startRecording()
            } else {
                finishRecording(success: true)
            }
    }
    @IBAction func ListenButton(_ sender: Any) {
        //playSound()
        playRecording()
        print("Listen Button")
    }
    @IBAction func StopButton(_ sender: Any) {
        stopSound()
        print("Stop Button")
    }

    //재생 중단 함수
    func stopSound(){
        player.stop()
    }
    
    //녹음된 파일 재생하는 함수
    func playRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        do {
            player = try AVAudioPlayer(contentsOf: audioFilename)
            player?.volume = recordingSession.outputVolume
            player?.delegate = self
            player?.play()
        } catch {
            // Error playing audio file
        }
    }
    
    //재생 중단 관련 stop 함수
    private func stop() {
        if let recorder: AVAudioRecorder = self.audioRecorder {
            recorder.stop()
            let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(false)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    //재생 관련 play 함수
    private func play() {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                let audioSession = AVAudioSession.sharedInstance()
                player = try? AVAudioPlayer(contentsOf: recorder.url)
                player?.volume = audioSession.outputVolume
                player?.delegate = self
                player?.play()
            }
        }
    }
    
    //마이크 권한 요청 부분
    func requestMicrophoneAccess(completion: @escaping (Bool) -> Void) {
        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        switch audioSession.recordPermission {
        case .undetermined: // 아직 녹음 권한 요청이 되지 않음, 사용자에게 권한 요청
            audioSession.requestRecordPermission({ allowed in
                completion(allowed)
            })
        case .denied: // 사용자가 녹음 권한 거부, 사용자가 직접 설정 화면에서 권한 허용을 하게끔 유도
            print("[Failure] Record Permission is Denied.")
            completion(false)
        case .granted: // 사용자가 녹음 권한 허용
            print("[Success] Record Permission is Granted.")
            completion(true)
        @unknown default:
            fatalError("[ERROR] Record Permission is Unknown Default.")
        }
    }
    
    //녹음 시작 기능 함수
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            print("녹음 시작")
            audioRecorder.record()

        } catch {
            finishRecording(success: false)
        }
    }
    
    //녹음 파일 저장 경로 함수
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //녹음 종료 기능 함수
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            print("녹음 완료")
            let base64String = encodeRecordingToBase64()
            
            // Send the encoded audio file to the REST API.
            postTest(base64String: base64String!)
            //sendEncodedRecordingToApi(base64String: base64String!)
            print("발음평가 전송완료")
        } else {
        }
    }
}
extension RecordTestPageController {

    // Encodes the recorded audio file to base64.
    func encodeRecordingToBase64() -> String? {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        // Create a Data object from the audio file.
        let audioData = try? Data(contentsOf: audioFilename)

        // Encode the Data object to base64.
        let base64String = audioData?.base64EncodedString()
        
        print(base64String!)

        return base64String!
    }
    
    func postTest(base64String: String) {
            let url = "http://aiopen.etri.re.kr:8000/WiseASR/PronunciationKor"
            var request = URLRequest(url: URL(string: url)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("API-KEYS", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 15
            // POST 로 보낼 정보
            let parameters: Parameters = [
                "argument": [
                    "language_code": "korean",
                    "script": "간장공장 공장장",
                    "audio": base64String,
                ],
            ]
            
            // httpBody 에 parameters 추가
            do {
                try request.httpBody = JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                print("http Body Error")
            }
            AF.request(request).responseString { (response) in
                switch response.result {
                case .success:
                    print("POST 성공")
                    if let json = try? JSONDecoder().decode([String: String].self, from: response.data!) {
                        let returnObject: Dictionary<String, Any> = json["return_object"] as? Dictionary<String, Any> ?? [:]
                        if let recognized = returnObject["recognized"] as? String,
                           let score = returnObject["score"] as? Int {
                            print("발음평가 결과: \(recognized)")
                            print("발음 평가 점수: \(score)")
                        }
                    }
                case .failure(let error):
                    print("error : \(error.errorDescription!)")
                }
            }
        }
    
    // Sends the encoded audio file to the REST API.
        func sendEncodedRecordingToApi(base64String: String) {
            let url = URL(string: "http://aiopen.etri.re.kr:8000/WiseASR/PronunciationKor")!
            let headers: HTTPHeaders = [
                "Content-Type" : "application/json",
                "Authorization": "API-KEYS",
            ]
            let parameters: Parameters = [
                "argument": [
                    "language_code": "korean",
                    "script": "간장공장 공장장",
                    "audio": base64String,
                ],
            ]
            
            AF.request(url, method: .post, parameters: parameters, headers: headers).validate(contentType: ["application/json"])
                        .responseJSON { response in
                            switch response.result {
                            case .success:
                                // Handle the success response.
                                print(response)
                                if let json = try? JSONDecoder().decode([String: String].self, from: response.data!) {
                                    let returnObject: Dictionary<String, Any> = json["return_object"] as? Dictionary<String, Any> ?? [:]
                                    if let recognized = returnObject["recognized"] as? String,
                                       let score = returnObject["score"] as? Int {
                                        print("발음평가 결과: \(recognized)")
                                        print("발음 평가 점수: \(score)")
                                    }
                                }
                            case .failure:
                                print("전송 실패")
                                
                                // Handle the failure response.
                            }
                        }
                }
}
