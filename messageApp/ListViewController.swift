//
//  ListViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/17.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MoveDelegate {
    
    var ref : DatabaseReference!              //Firebaseを使用
    
    var currentUser = Auth.auth().currentUser //ログインしているユーザー
    var currentChatID = ""                    //ログインしているユーザーのchatID
    var otherChatID = ""                      //相手のchatID
    var currentUserName = ""                  //ログインしているユーザーのuserName
    var otherUserName = ""                    //相手のUserName
    var rooms: [Room] = []                    //トークルームを管理する配列
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriendAddViewController" {
            var nextViewController: FriendAddViewController = segue.destination as! FriendAddViewController
            nextViewController.delegate = self
        }
        else if segue.identifier == "toTalkRoomViewController" {
            var nextViewController: TalkRoomViewController = segue.destination as! TalkRoomViewController
            nextViewController.currentRoom = sender as! Room
        }
    }
    
    @IBAction func pushPlus() { //プラスbutton
        self.performSegue(withIdentifier: "toFriendAddViewController", sender: nil)
    }
    
    func didInput() { //Firebaseの操作
        
        //インスタンス生成
        ref = Database.database().reference()
        
        //FirebaseからUserListを持ってくる
        ref.child("UserList").observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            
            guard let userList = snapshot.children.allObjects as? [DataSnapshot] else {
                print("no list")
                return
            }
            
            for item in userList {
                guard let value = item.value as? NSDictionary else { return }
                let searchUser = User(uid: item.key,
                                      chatID: value["chatID"]! as! String,
                                      userName: value["userName"]! as! String)
                
                //自分のchatID・userNameを取得
                if self.currentUser!.uid == searchUser.uid {
                    self.currentChatID = searchUser.chatID
                    self.currentUserName = searchUser.userName
                }
            }
            
            //            self.currentChatID = (snapshot.value! as AnyObject).description
            
            //FirebaseからRoomIDを持ってくる
            self.ref.child("RoomList").observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let roomList = snapshot.children.allObjects as? [DataSnapshot] else {
                    print("no list")
                    return
                }
                
                for item in roomList {
                    guard let value = item.value as? NSDictionary else { return }
                    let searchRoom = Room(roomID: item.key,
                                          chatID1: value["chatID1"]! as! String,
                                          chatID2: value["chatID2"]! as! String,
                                          userName1: value["userName1"]! as! String,
                                          userName2: value["userName2"]! as! String)
                    
                    //自分のchatIDとchatID1が一致するか調べる
                    if self.currentChatID == searchRoom.chatID1 {
                        print("chatID1と一致")
                        self.rooms.append(searchRoom)
                        self.otherUserName = searchRoom.userName2
                        print(self.rooms)
                    }
                    
                    //自分のchatIDとchatID2が一致するか調べる
                    if self.currentChatID == searchRoom.chatID2 {
                        print("chatID2と一致")
                        self.rooms.append(searchRoom)
                        self.otherUserName = searchRoom.userName1
                    }
                    print(self.rooms)
                }
                self.tableView.reloadData()
            })
            print(self.currentChatID)
            print(self.rooms)
        })
        print(self.rooms)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int { //セルの数
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //セルの文字
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        if currentUserName == rooms[indexPath.row].userName1 {
            cell?.textLabel?.text = rooms[indexPath.row].userName2
        } else {
            cell?.textLabel?.text = rooms[indexPath.row].userName1
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //セルにタップした時の処理
        self.performSegue(withIdentifier: "toTalkRoomViewController", sender: rooms[indexPath.row])
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
