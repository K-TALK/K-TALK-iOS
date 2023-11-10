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
import ProgressHUD
import RealmSwift

class RecordTestPageController : UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    var player : AVAudioPlayer!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    var currentSentenceId: Int = 1
    
    var currentSentence: String = ""
    
    // Realm 가져오기
    let realm = try? Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("## realm file dir -> \(Realm.Configuration.defaultConfiguration.fileURL!)")
        inputSentece()
        
        self.SentenceView.text = "간장공장 공장장"
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // 녹음 실패
                    }
                }
            }
        } catch {
            // 녹음 실패!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    @IBOutlet weak var Score: UILabel!
    
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
    
    @IBOutlet weak var SentenceView: UILabel!
    
    @IBAction func SentenceRight(_ sender: Any) {
        //realm 호출
        let sentenceData = realm?.objects(Sentence.self).sorted(byKeyPath: "id", ascending: true)

        // 다음 문장의 ID를 계산합니다.
        var nextSentenceId = currentSentenceId + 1
        if nextSentenceId > getRealmData() {
                nextSentenceId = 1
        }

        // 다음 문장의 객체를 가져옵니다.
        let nextSentence = sentenceData?[nextSentenceId - 1]

        // 화면에 다음 문장을 표시합니다.
        self.SentenceView.text = nextSentence?.sentence
        currentSentence = nextSentence!.sentence

        // 다음 문장의 ID를 현재 문장의 ID로 설정합니다.
        currentSentenceId = nextSentenceId
        self.Score.text = "녹음 버튼을 눌러주세요!"
        
        print(currentSentenceId)
        print(currentSentence)
    }
    
    @IBAction func SentenceLeft(_ sender: Any) {
        //realm 호출
        let sentenceData = realm?.objects(Sentence.self).sorted(byKeyPath: "id", ascending: true)

        // 이전 문장의 ID를 계산합니다.
        var previousSentenceId = currentSentenceId - 1
        if previousSentenceId == 0 {
            previousSentenceId = getRealmData()
        }

        // 이전 문장의 객체를 가져옵니다.
        let previousSentence = sentenceData?[previousSentenceId - 1]

        // 화면에 다음 문장을 표시합니다.
        self.SentenceView.text = previousSentence?.sentence
        currentSentence = previousSentence!.sentence


        // 다음 문장의 ID를 현재 문장의 ID로 설정합니다.
        currentSentenceId = previousSentenceId
        
        self.Score.text = "녹음 버튼을 눌러주세요!"
        
        print(currentSentenceId)
        print(currentSentence)
    }
    

    //재생 중단 함수
    func stopSound(){
        player.stop()
    }
    
    //녹음된 파일 재생하는 함수
    func playRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")

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
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            print("녹음 시작")
            self.Score.text = "녹음중···"
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
            self.Score.text = "계산중···"
            print("녹음 완료")
            let base64String = encodeRecordingToBase64()
            
            // Send the encoded audio file to the REST API.
            postTest(base64String: base64String!)
            print("발음평가 전송완료")
        } else {
        }
    }
    
    //realm 문장 입력
    func inputSentece(){
        let sentence1 = Sentence()
        sentence1.sentence = "간장공장 공장장"
        sentence1.id = 1

        let sentence2 = Sentence()
        sentence2.sentence = "내가그린 기린그림"
        sentence2.id = 2
        
        let sentence3 = Sentence()
        sentence3.sentence = "경찰청 쇠창살"
        sentence3.id = 3
        
        let sentence4 = Sentence()
        sentence4.sentence = "가나다라마바사"
        sentence4.id = 4
        
        let sentence5 = Sentence()
        sentence5.sentence = "동해물과 백두산이"
        sentence5.id = 5
        
        if getRealmData() == 0 {
            // Realm DB에 데이터가 없습니다.
            try! realm?.write {
                realm?.add(sentence1)
                realm?.add(sentence2)
                realm?.add(sentence3)
                realm?.add(sentence4)
                realm?.add(sentence5)
            }
        } else {
            // Realm DB에 데이터가 있습니다.
            print("Realm DB에 이미 데이터가 있습니다.")
        }
    }
    
    //realm 호출
    func getRealmData() -> Int {
        // Realm DB에서 모든 Record 객체를 가져옵니다.
        if let realm = realm {
            // Realm DB를 사용합니다.
            let sentence = realm.objects(Sentence.self)

            // 문장의 총 개수를 저장합니다.
            let totalCount = sentence.count

            // `totalCount` 변수를 반환합니다.
            return totalCount
        } else { return 0
            // Realm DB가 nil입니다. 적절한 처리를 합니다.
        }
    }
}
extension RecordTestPageController {

    // Encodes the recorded audio file to base64.
    func encodeRecordingToBase64() -> String? {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.wav")

        // Create a Data object from the audio file.
        let audioData = try? Data(contentsOf: audioFilename)

        // Encode the Data object to base64.
        let base64String = audioData?.base64EncodedString()
        
        print(base64String!)

        return base64String!
    }
    
    func postTest(base64String: String) {
        let url = "http://aiopen.etri.re.kr:8000/WiseASR/PronunciationKor"
        
        struct Response: Codable {
            let result: Int
            let return_type: String
            let return_object: ReturnObject

            struct ReturnObject: Codable {
                let recognized: String
                let score: String
            }
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("API-Keys", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 15
        
        // POST 로 보낼 정보
        let argument: [String: Any] = [
            "language_code": "korean",
            "script": currentSentence,
            "audio": base64String,
        ] as Dictionary
            
        let parameters: [String: Any] = [
            "argument": argument
        ] as Dictionary
            
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch {
            print("http Body Error")
        }
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
                if let json = try? JSONDecoder().decode(Response.self, from: response.data!) {
                    print(json.return_object.recognized)
                    print(json.return_object.score)
                    
                    // 점수 정보를 Float형으로 변환
                    let score = Float(json.return_object.score) ?? 0

                    // 0~100점으로 환산
                    let convertedScore = Double((score - 1) * 25)
                    let formattedScore = String(format: "%.2f", convertedScore)

                    self.Score.text = "\(String(formattedScore))점"
                    
                }
            case .failure(let error):
                print("error : \(error.errorDescription!)")
            }
        }
    }
}
