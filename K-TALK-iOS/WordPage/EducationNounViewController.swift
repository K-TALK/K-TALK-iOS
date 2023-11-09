//
//  EducationVerbViewController.swift
//  K-TALK-iOS
//
//  Created by 박세인 on 2023/11/09.
//

import Foundation
import UIKit
import RealmSwift

class EducationNounViewController: UIViewController {
    @IBOutlet var wordLabel: UILabel!
    @IBOutlet var exampleLabel: UILabel!
    @IBOutlet var meaningLabel: UILabel!
    
    var currentIndex: Int = 0
    var doesNotEndWith: Results<SampleData>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Realm에서 "~다"로 끝나는 단어 필터링
        let realm = try! Realm()
        doesNotEndWith = realm.objects(SampleData.self).filter("NOT wordname ENDSWITH '다'")

        
        // 화면 초기화
        showWord(at: currentIndex)
    }
    
    func showWord(at index: Int) {
        if index >= 0 && index < doesNotEndWith.count {
            let wordItem = doesNotEndWith[index]
            
            wordLabel.text = "단어: " + wordItem.wordname
            exampleLabel.text = "예시: " + wordItem.example
            meaningLabel.text = "의미: " + wordItem.wordmean
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        currentIndex += 1
        if currentIndex >= doesNotEndWith.count {
            currentIndex = 0
        }
        showWord(at: currentIndex)
    }
}
