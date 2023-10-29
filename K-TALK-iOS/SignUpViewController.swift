//
//  SignUpViewController.swift
//  K-TALK-iOS
//
//  Created by 장지수 on 2023/10/29.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController{

    @IBOutlet weak var reTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var PasswordConfirmed: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reTextField.delegate = self
        pwTextField.delegate = self
        emailTextField.delegate = self
        PasswordConfirmed.text = ""
        // Do any additional setup after loading the view.
    }
    @IBAction func signUpButtonTouched(_ sender: UIButton) {
        guard let userEmail = emailTextField.text,
              let userPassword = pwTextField.text,
              let userPasswordConfirm = reTextField.text else {
            return
        }
        
        guard userPassword != ""
                && userPasswordConfirm != ""
                && userPassword == userPasswordConfirm else {
            print("패스워드가 x")
            return
        }
        
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { [self] authResult, error in
            // 이메일, 비밀번호 전송
            guard let user = authResult?.user, error == nil else {
                print("이미 가입된 정보입니다.")
                return
            }
           print("\(user.email!) 님의 회원가입이 완료되었습니다.")
                self.dismiss(animated: true, completion: nil)
        }
    }
}
extension SignUpViewController: UITextFieldDelegate {
    
    func setLabelPasswordConfirm(_ password: String, _ passwordConfirm: String)  {
        
        guard passwordConfirm != "" else {
            PasswordConfirmed.text = ""
            return
        }
        
        if password == passwordConfirm {
            PasswordConfirmed.textColor = .green
            PasswordConfirmed.text = "패스워드가 일치합니다."
        } else {
            PasswordConfirmed.textColor = .red
            PasswordConfirmed.text = "패스워드가 일치하지 않습니다."
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case emailTextField:
            pwTextField.becomeFirstResponder()
        case pwTextField:
            reTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == reTextField {
            guard let password = pwTextField.text,
                  var passwordConfirmBefore = reTextField.text else {
                return true
            }
            if let range = Range(range, in: passwordConfirmBefore) {
                passwordConfirmBefore.replaceSubrange(range, with: string)
            }
            
            setLabelPasswordConfirm(password, passwordConfirmBefore)
        }
        return true
    }
}
