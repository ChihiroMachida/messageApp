//
//  ListViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/17.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, MoveDelegate {
    
    var ref : DatabaseReference!              //Firebaseを使用
    var delegate = MoveDelegate.self          //デリゲートを設定
    var currentUser = Auth.auth().currentUser //ログインしているユーザー
    var otherUserName = ""                    //相手のUserName
    var rooms: [Room] = []                   //トークルームを管理する配列
    
    @IBOutlet var tableView: UITableView! //友だちを表示するTableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self as? UITableViewDataSource //データソースを使用
        tableView.delegate = self                             //デリゲートを使用
        
        didInput()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushPlus() { //プラスbutton
            self.performSegue(withIdentifier: "toFriendAddViewController", sender: self.delegate)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendAddViewController" {
            let secondViewController = segue.destination as! FriendAddViewController
            secondViewController.delegate = self
        }
    }
    
    func didInput() { //Firebaseの操作
        var currentChatID = "" //ログインしているユーザーのchatID
        var otherChatID = ""   //相手のchatID
        
        //インスタンス生成
        ref = Database.database().reference()
        
        //FirebaseからUserListを持ってくる
        ref.child("UserList").observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let list = snapshot.children.allObjects as? [DataSnapshot] else {
                print("no list")
                return
            }
            
            for item in list {
                guard let value = item.value as? NSDictionary else { return }
                let searchUser = User(uid: item.key,
                                      chatID: value["chatID"]! as! String,
                                      userName: value["userName"]! as! String)
                
                //自分のchatIDを取得
                if self.currentUser!.uid == searchUser.uid {
                    currentChatID = searchUser.uid
                }
            }
        })
        
        //FirebaseからRoomIDを持ってくる
        ref.child("RoomList").observeSingleEvent(of: .value, with: { (snapshot) in

            guard let list = snapshot.children.allObjects as? [DataSnapshot] else {
                print("no list")
                return
            }
            
            for item in list {
                guard let value = item.value as? NSDictionary else { return }
                let searchRoom = Room(chatID1: value["chatID1"]! as! String,
                                      chatID2: value["chatID2"]! as! String,
                                      userName1: value["userName1"]! as! String,
                                      userName2: value["userName2"]! as! String)
                
                //自分のchatIDとchatID1が一致するか調べる
                if currentChatID == searchRoom.chatID1 {
                    self.rooms += [searchRoom]
                    self.otherUserName = searchRoom.userName2
                }
                
                //自分のchatIDとchatID2が一致するか調べる
                if currentChatID == searchRoom.chatID2 {
                    self.rooms.append(searchRoom)
                    self.otherUserName = searchRoom.userName1
                }
                
                print(searchRoom.userName1, searchRoom.userName2)
            }
        })
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int { //セルの個数
            return rooms.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //セルの個数
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            
            //セルに相手の名前を表示する
            cell?.textLabel?.text = otherUserName
            
            return cell!
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
