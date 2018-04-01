//
//  SignUpViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/17.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

//TextFieldを下線のみにするextension
extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!                   //Firebaseを使用
    
    @IBOutlet var userNameTextField: UITextField! //ユーザー名を入力するTextField
    @IBOutlet var chatIDTextField: UITextField!   //チャットIDを入力するTextField
    @IBOutlet var emailTextField: UITextField!    //メールアドレスを入力するTextField
    @IBOutlet var passwordTextField: UITextField! //パスワードを入力するTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //インスタンス生成
        ref = Database.database().reference()
        
        passwordTextField.delegate = self
        
        //デリゲートを指定
        passwordTextField.delegate = self
        
        //TextFieldの下線を追加
        userNameTextField.placeholder = "ユーザー名"
        userNameTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        chatIDTextField.placeholder = "チャットID"
        chatIDTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        emailTextField.placeholder = "メールアドレス"
        emailTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        passwordTextField.placeholder = "パスワード"
        passwordTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Returnキーが押されたら呼び出されるメソッド
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        //キーボードをしまう
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func pushSignUp() { //新規登録button
        
        if let userName = userNameTextField.text,
           let chatID = chatIDTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text {
            if userName.characters.isEmpty { //usernameが入力されてなかった時の処理
                userNameTextField.layer.borderColor = UIColor.red.cgColor
                SVProgressHUD.showError(withStatus: "入力してください")
                return
            }
            if email.characters.isEmpty { //emailが入力されてなかった時の処理
                emailTextField.layer.borderColor = UIColor.red.cgColor
                SVProgressHUD.showError(withStatus: "入力してください")
                return
            }
            if password.characters.isEmpty { //passwordが入力されてなかった時の処理
                passwordTextField.layer.borderColor = UIColor.red.cgColor
                SVProgressHUD.showError(withStatus: "入力してください")
                return
            }
            userNameTextField.layer.borderColor = UIColor.black.cgColor
            emailTextField.layer.borderColor = UIColor.black.cgColor
            passwordTextField.layer.borderColor = UIColor.black.cgColor
            
            SVProgressHUD.show()
            
            //ユーザー作成
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if let error = error {
                    print(error)
                    SVProgressHUD.showError(withStatus: "エラー")
                    return
                }
                
                //ユーザー名設定
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = userName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            print(error)
                            SVProgressHUD.showError(withStatus: "エラー")
                            return
                        }
                        SVProgressHUD.showSuccess(withStatus: "登録完了！")
                        
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when) {
                            self.present((self.storyboard?.instantiateViewController(withIdentifier: "navigationController"))!,
                                         animated: true,
                                         completion: nil)
                        }
                    }
                } else {
                    print("error - user not found")
                }
                SVProgressHUD.dismiss()
                self.ref?.child("UserList").childByAutoId().setValue(["userName": userName, "chatID": chatID])
                
            }
        }
    }
    
    func textFieldShouldReturn(passwordTextField: UITextField) -> Bool {
        passwordTextField.resignFirstResponder()
        return true
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
