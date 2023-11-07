//
//  LoginViewController.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/10/25.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwShowButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        pwTextField.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonTouched(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
            if user != nil{
                print("login success")
                if let mainPageVC = self.storyboard?.instantiateViewController(withIdentifier: "MainPageView") as? UITabBarController {
                    mainPageVC.selectedIndex = 0
                    mainPageVC.modalPresentationStyle = .fullScreen
                    self.present(mainPageVC, animated: true, completion: nil)
                }
            }
            else{
                print("login fail")
            }
        }
    }
    @IBAction func pwShowButtonTouched(_ sender: Any) {
        if pwTextField.isSecureTextEntry == true {
            if let image = UIImage(systemName: "eye.fill") {
                pwShowButton.setImage(image, for: .normal)
            }
            pwTextField.isSecureTextEntry = false
        } else {
            if let image = UIImage(systemName: "eye.slash.fill") {
                pwShowButton.setImage(image, for: .normal)
            }
            pwTextField.isSecureTextEntry = true
        }
    }
}
