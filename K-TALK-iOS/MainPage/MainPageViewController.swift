//
//  MainPageViewController.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/11/01.
//

import UIKit
import FirebaseAuth
class MainPageViewController: UIViewController {
    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var education: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Firebase에서 현재 사용자 정보 가져오기
        if let currentUser = Auth.auth().currentUser {
            // 현재 사용자의 이메일 표시
            welcome.text = "\(currentUser.email!)님 환영합니다!"
        }
        let jsonData = readJson()
        jsonData.readJson()
    }
    @IBAction func moveEducationN(_ sender: UIButton){
        let viewController = storyboard?.instantiateViewController(withIdentifier: "EducationMainViewController") as! UIViewController
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
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
