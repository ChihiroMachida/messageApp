//
//  FriendAddViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/03/08.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase

protocol MoveDelegate { //プロトコル
    func didInput()
}

class FriendAddViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference!               //Firebaseを使用
    var delegate: MoveDelegate?               //デリゲート
    var currentUser = Auth.auth().currentUser //ログインしているユーザー
    
    @IBOutlet var friendChatIDTextField: UITextField! //友だちのチャットIDを入力するTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //インスタンス生成
        ref = Database.database().reference()
        
        //デリゲートを指定
        friendChatIDTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushAdd() { //追加button
        
        //FirebaseからUserListを持ってくる
        ref.child("UserList").observeSingleEvent(of: .value, with: { (snapshot) in
            var currentChatID = ""                              //ログインしているユーザーのchatID
            var otherChatID = ""                                //追加する相手のchatID
            var currentUserName = self.currentUser?.displayName //ログインしているユーザーのuserName
            var otherUserName = ""                              //追加する相手のuserName
            
            guard let list = snapshot.children.allObjects as? [DataSnapshot]  else {
                print("no list")
                return
            }
            
            //入力したIDがDatabaseにあるか調べる
            for item in list {
                guard let value = item.value as? NSDictionary else { return }
                print(item.key)
                let searchUser = User(uid: item.key,
                                 chatID: value["chatID"]! as! String,
                                 userName: value["userName"]! as! String)
                print(searchUser.chatID)
                
                //自分のchatIDを取得
                if self.currentUser!.uid == searchUser.uid {
                    currentChatID = searchUser.chatID
                }
                
                // 他の人のIDを取得
                if self.friendChatIDTextField.text == searchUser.chatID {
                    otherChatID = searchUser.chatID
                    otherUserName = searchUser.userName
                }
            }
            
            //roomIDを生成
            self.ref?.child("RoomList").childByAutoId().setValue(["chatID1": currentChatID, "chatID2": otherChatID, "userName1": currentUserName, "userName2": otherUserName])
            print(currentChatID)
            print(otherChatID)
            
            self.delegate?.didInput()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func pushClose() { //キャンセルbutton
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool { //Returnキー
        //キーボードをしまう
        textField.resignFirstResponder()
        return false
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
