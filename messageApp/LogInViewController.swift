//
//  LogInViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/17.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LogInViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!    //メールアドレスを入力するTextField
    @IBOutlet var passwordTextField: UITextField! //パスワードを入力するTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func pushLogIn() {
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            if email.characters.isEmpty { //メールアドレスが入力されてなかった時の処理
                emailTextField.layer.borderColor = UIColor.red.cgColor
                SVProgressHUD.showError(withStatus: "No Email")
                return
            }
            if password.characters.isEmpty { //パスワードが入力されてなかった時の処理
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                SVProgressHUD.showError(withStatus: "No Password")
                return
            }
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
            
            SVProgressHUD.show()
            
            //ログイン
            Auth.auth().signIn(withEmail: email, password: password) { user, error in
                if let errpr = error {
                    print(error)
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    return
                } else {
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when) {self.present((self.storyboard?.instantiateViewController(withIdentifier: "listViewController"))!,
                                        animated: true,
                                        completion: nil)
                    }
                    
                }
            
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
