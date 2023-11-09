//
//  QuizPageController.swift
//  K-TALK-iOS
//
//  Created by JungGue LEE on 2023/11/07.
//

import Foundation
import UIKit
import RealmSwift

// Realm 가져오기
let realm = try? Realm()

var question: String = ""
var answer1: String = ""
var answer2: String = ""
var answer3: String = ""
var answer4: String = ""
var correctAnswer: String = ""
var selectedAnswer: String = ""
var currentQuizId: Int = 1
var currentQuiz: String = ""

class QuizPageController : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        inputSentece()
        // Do any additional setup after loading the view.
        
        let QuizData = realm?.objects(Quiz.self).sorted(byKeyPath: "id", ascending: true)
        
        let FirstQuiz = QuizData?[0]
        
        // 퀴즈 정보를 설정합니다.
        question = FirstQuiz!.Quiz
        answer1 = FirstQuiz!.Answer1
        answer2 = FirstQuiz!.Answer2
        answer3 = FirstQuiz!.Answer3
        answer4 = FirstQuiz!.Answer4
        correctAnswer = FirstQuiz!.Answer2

        // 퀴즈를 표시합니다.
        QuizLabel.text = question
        answer1Button.setTitle(answer1, for: .normal)
        answer2Button.setTitle(answer2, for: .normal)
        answer3Button.setTitle(answer3, for: .normal)
        answer4Button.setTitle(answer4, for: .normal)
        
        QuizLabel.sizeToFit()
        answer1Button.sizeToFit()
        answer2Button.sizeToFit()
        answer3Button.sizeToFit()
        answer4Button.sizeToFit()
        QuizStack.sizeToFit()
        
    }
    
    @IBOutlet weak var QuizNum: UILabel!
    @IBOutlet weak var QuizLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var answer3Button: UIButton!
    @IBOutlet weak var answer4Button: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var AnswerButton: UIButton!
    @IBOutlet weak var goNext: UIButton!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var QuizStack: UIStackView!
    
    @IBAction func asnwer1ButtonAction(_ sender: Any) {
        selectedAnswer = answer1
        //realm 주소 확인용
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // 버튼의 색상을 systemCyan으로 변경
        answer1Button.tintColor = UIColor.systemCyan
        print(selectedAnswer)
        
    }
    
    @IBAction func asnwer2ButtonAction(_ sender: Any) {
        selectedAnswer = answer2
        
        answer2Button.tintColor = UIColor.systemCyan
        print(selectedAnswer)
    }
    
    @IBAction func asnwer3ButtonAction(_ sender: Any) {
        selectedAnswer = answer3
        
        answer3Button.tintColor = UIColor.systemCyan
        print(selectedAnswer)
    }
    
    @IBAction func asnwer4ButtonAction(_ sender: Any) {
        selectedAnswer = answer4
        
        answer4Button.tintColor = UIColor.systemCyan
        print(selectedAnswer)
    }
    
    @IBAction func answerButtonTapped(_ sender: Any
    ) {
        // 채점
        if selectedAnswer == correctAnswer {
        // 정답
            AnswerButton.tintColor = UIColor.systemGreen
            AnswerButton.setTitle("정답", for: .normal)
            if answer1 == selectedAnswer {
                answer1Button.tintColor = UIColor.systemGreen
            }
            if answer2 == selectedAnswer {
                answer2Button.tintColor = UIColor.systemGreen
            }
            if answer3 == selectedAnswer {
                answer3Button.tintColor = UIColor.systemGreen
            }
            if answer4 == selectedAnswer {
                answer4Button.tintColor = UIColor.systemGreen
            }
        } else {
            // 오답
            AnswerButton.tintColor = UIColor.systemRed
            AnswerButton
                .setTitle("오답", for: .normal)
            if answer1 == selectedAnswer {
                answer1Button.tintColor = UIColor.systemRed
            }
            if answer2 == selectedAnswer {
                answer2Button.tintColor = UIColor.systemRed
            }
            if answer3 == selectedAnswer {
                answer3Button.tintColor = UIColor.systemRed
            }
            if answer4 == selectedAnswer {
                answer4Button.tintColor = UIColor.systemRed
            }
        }
    }

    @IBAction func resetButton(_ sender: Any) {
        selectedAnswer = ""
        AnswerButton.tintColor = UIColor.systemBlue
        answer1Button.tintColor = UIColor.systemBlue
        answer2Button.tintColor = UIColor.systemBlue
        answer3Button.tintColor = UIColor.systemBlue
        answer4Button.tintColor = UIColor.systemBlue
    }
    
    @IBAction func goNext(_ sender: Any) {
        //realm 호출
        let QuizData = realm?.objects(Quiz.self).sorted(byKeyPath: "id", ascending: true)

        // 다음 문장의 ID를 계산합니다.
        var nextQuizId = currentQuizId + 1
        if nextQuizId > getRealmData(){
            nextQuizId = 1
        }

        // 다음 문장의 객체를 가져옵니다.
        let nextQuiz = QuizData?[nextQuizId - 1]

        // 화면에 다음 문장을 표시합니다.
        self.QuizLabel.text = nextQuiz?.Quiz
        currentQuiz = nextQuiz!.Quiz

        // 다음 문장의 ID를 현재 문장의 ID로 설정합니다.
        currentQuizId = nextQuizId
        self.QuizNum.text = "Quiz"+"\(nextQuiz!.id)"
        
        // 다음 문장의 답변을 표시합니다.
        answer1 = nextQuiz!.Answer1
        answer2 = nextQuiz!.Answer2
        answer3 = nextQuiz!.Answer3
        answer4 = nextQuiz!.Answer4
        answer1Button.setTitle(answer1, for: .normal)
        answer2Button.setTitle(answer2, for: .normal)
        answer3Button.setTitle(answer3, for: .normal)
        answer4Button.setTitle(answer4, for: .normal)
        correctAnswer = nextQuiz!.correctAnswer
        
        selectedAnswer = ""
        AnswerButton.tintColor = UIColor.systemBlue
        answer1Button.tintColor = UIColor.systemBlue
        answer2Button.tintColor = UIColor.systemBlue
        answer3Button.tintColor = UIColor.systemBlue
        answer4Button.tintColor = UIColor.systemBlue
        
        print(currentQuizId)
    }
    
    @IBAction func goBack(_ sender: Any) {
        //realm 호출
        let QuizData = realm?.objects(Quiz.self).sorted(byKeyPath: "id", ascending: true)

        // 다음 문장의 ID를 계산합니다.
        var previousQuizId = currentQuizId - 1
        if previousQuizId == 0{
            previousQuizId = getRealmData()
        }

        // 다음 문장의 객체를 가져옵니다.
        let previousQuiz = QuizData?[previousQuizId - 1]

        // 화면에 다음 문장을 표시합니다.
        self.QuizLabel.text = previousQuiz?.Quiz
        currentQuiz = previousQuiz!.Quiz

        // 다음 문장의 ID를 현재 문장의 ID로 설정합니다.
        currentQuizId = previousQuizId
        self.QuizNum.text = "Quiz"+"\(previousQuiz!.id)"
        
        // 다음 문장의 답변을 표시합니다.
        answer1 = previousQuiz!.Answer1
        answer2 = previousQuiz!.Answer2
        answer3 = previousQuiz!.Answer3
        answer4 = previousQuiz!.Answer4
        answer1Button.setTitle(answer1, for: .normal)
        answer2Button.setTitle(answer2, for: .normal)
        answer3Button.setTitle(answer3, for: .normal)
        answer4Button.setTitle(answer4, for: .normal)
        correctAnswer = previousQuiz!.correctAnswer
        
        selectedAnswer = ""
        AnswerButton.tintColor = UIColor.systemBlue
        answer1Button.tintColor = UIColor.systemBlue
        answer2Button.tintColor = UIColor.systemBlue
        answer3Button.tintColor = UIColor.systemBlue
        answer4Button.tintColor = UIColor.systemBlue
        
        print(currentQuizId)
    }
    
    
    func inputSentece(){
        let Quiz1 = Quiz()
        Quiz1.id = 1
        Quiz1.Quiz = "다음 중 \"발로 내지르거나 받아 올리다\"" + "의 의미를 가진 \"차다\"" + "의 올바른 예시를 고르시오"
        Quiz1.Answer1 = "금메달을 딴 그는 기쁨에 찬 얼굴로 눈물을 흘렸다"
        Quiz1.Answer2 = "공을 차다"
        Quiz1.Answer3 = "바람이 차다"
        Quiz1.Answer4 = "버스에 사람이 가득 차다"
        Quiz1.correctAnswer = "공을 차다"
        
        let Quiz2 = Quiz()
        Quiz2.id = 2
        Quiz2.Quiz = "다음 중 \"빛의 자극을 받아 물체를 볼 수 있는 감각 기관\"" + "의 의미를 가진 \"눈\"" + "의 올바른 예시를 고르시오"
        Quiz2.Answer1 = "눈사람을 만들다"
        Quiz2.Answer2 = "눈이 내리다"
        Quiz2.Answer3 = "눈을 뜨다"
        Quiz2.Answer4 = "그는 보는 눈이 정확하다"
        Quiz2.correctAnswer = "눈을 뜨다"
        
        let Quiz3 = Quiz()
        Quiz3.id = 3
        Quiz3.Quiz = "다음 중 \"물기가 많아서 단단하지 않다\"" + "의 의미를 가진 \"무르다\"" + "의 올바른 예시를 고르시오"
        Quiz3.Answer1 = "마음이 그렇게 물러서 어떻게 이 험한 세상을 살겠느냐"
        Quiz3.Answer2 = "한번 산 물건은 무를 수 없다"
        Quiz3.Answer3 = "저지른 실수는 처음대로 무를 수가 없으니 매사에 신중해야 한다"
        Quiz3.Answer4 = "비 온 뒤라 땅이 무르니 발을 디딜 때 주의해라"
        Quiz3.correctAnswer = "비 온 뒤라 땅이 무르니 발을 디딜 때 주의해라"
        
        if getRealmData() == 0 {
            // Realm DB에 데이터가 없습니다.
            try! realm?.write {
                realm?.add(Quiz1)
                realm?.add(Quiz2)
                realm?.add(Quiz3)
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
            let Quiz = realm.objects(Quiz.self)

            // 문장의 총 개수를 저장합니다.
            let totalCount = Quiz.count

            // `totalCount` 변수를 반환합니다.
            return totalCount
        } else { return 0
            // Realm DB가 nil입니다. 적절한 처리를 합니다.
        }
    }
}
