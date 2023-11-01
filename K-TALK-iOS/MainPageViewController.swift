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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Firebase에서 현재 사용자 정보 가져오기
        if let currentUser = Auth.auth().currentUser {
            // 현재 사용자의 이메일 표시
            welcome.text = "\(currentUser.email!)님 환영합니다!"
        } else {
            // 사용자가 로그인하지 않은 경우에 대한 처리
            welcome.text = "로그인되지 않음"
        }
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
