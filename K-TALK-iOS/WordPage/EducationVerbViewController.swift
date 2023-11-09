import Foundation
import UIKit
import RealmSwift

class EducationVerbViewController: UIViewController {
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var exampleLabel: UILabel!
    @IBOutlet var meaningLabel: UILabel!
    
    var currentIndex: Int = 0
    var endsWith: Results<SampleData>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // "~다"로 끝나는 단어 필터링
        let realm = try! Realm()
        endsWith = realm.objects(SampleData.self).filter("wordname CONTAINS '다'")
        
        // 화면 초기화
        showWord(at: currentIndex)
    }
    func showWord(at index: Int) {
        if index >= 0 && index < endsWith.count {
            let wordItem = endsWith[index]
            
            wordLabel.text = "단어: " + wordItem.wordname
            exampleLabel.text = "예시: " + wordItem.example
            meaningLabel.text = "의미: " + wordItem.wordmean
        }
    }

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        currentIndex += 1
        if currentIndex >= endsWith.count {
            currentIndex = 0
        }
        showWord(at: currentIndex)
    }
}

