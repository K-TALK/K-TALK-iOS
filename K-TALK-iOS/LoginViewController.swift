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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func loginButtonTouched(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
            if user != nil{
                print("login success")
            }
            else{
                print("login fail")
            }
        }
    }
}
