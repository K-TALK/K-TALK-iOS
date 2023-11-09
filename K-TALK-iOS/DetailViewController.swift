//
//  DetailViewController.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/11/08.
//

import UIKit

class DetailViewController: UIViewController {
    var selectedWord: WordData?
    @IBOutlet weak var detailWord: UILabel!
    @IBOutlet weak var detailWordEx: UILabel!
    @IBOutlet weak var detailWordMean: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedWord = selectedWord {
            detailWord.text = selectedWord.단어
            detailWordEx.text = selectedWord.예시
            detailWordMean.text = selectedWord.의미// 디버깅 메시지
        }
    }

    @IBAction func backButtonTouched(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
