//
//  TalkRoomViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/17.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}

class TalkRoomViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var ref: DatabaseReference!               //インスタンス変数
    var currentUser = Auth.auth().currentUser //ログインしているユーザー
    var currentChatID = ""                    //ログインしているユーザーのchatID
    var otherUserName = ""                    //相手のuserName
    var currentRoom: Room!                    //トークルームのインスタンス
    var snapshot: DataSnapshot!
    
    var Array: [DataSnapshot] = []            //FetchしたSnapshotを格納
    
//    var myX: Int = 240                        //自分のフキダシのX座標
//    var myY: Int = 50                         //自分のフキダシのY座標
//    @IBOutlet var scrollView: UIScrollView!   //フキダシを表示するScrollView
    @IBOutlet var tableView: UITableView!     //フキダシを表示するTableView
//    private var myTalkView: UIView!           //自分のフキダシのView
//    private var myTalkLabel: UILabel!         //自分のフキダシのLabel
    @IBOutlet var sendButton: UIButton!       //送信button
    @IBOutlet var textField: UITextField!     //コメントを入力するTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.becomeFirstResponder()
        
        //インスタンス生成
        ref = Database.database().reference()
        
        //ログインしているユーザーのchatIDを取得
        ref.child("UserList").child((currentUser?.uid)!).child("chatID").observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            self.currentChatID = (snapshot.value! as AnyObject).description
            
            if self.currentChatID == self.currentRoom.chatID1 {
                print("chatID1と一致")
                self.navigationItem.title = self.currentRoom.userName2
            } else {
                print("chatID2と一致")
                self.navigationItem.title = self.currentRoom.userName1
            }
        })
        //データの読み込み
        self.read()
        
        //デリゲート・データソースの設定
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self as? UITableViewDataSource
        
        //カスタムクラスの作成
        tableView.register(UINib(nibName: "MyTalkTableViewCell", bundle: nil), forCellReuseIdentifier: "MyTalk")
        tableView.register(UINib(nibName: "YourTalkTableViewCell", bundle: nil), forCellReuseIdentifier: "YourTalk")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Cellの高さを調節
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //画面が消えたときに、Firebaseのデータ読み取りのObserverを削除する
        ref.removeAllObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushSend() { //送信button
        //データの作成
        send()
        
        //textFieldを空にする
        textField.text = ""
    }
    
    func send() { //データの作成の関数
        guard let text = textField.text else { return }
        self.ref.child("RoomList").child(currentRoom.roomID).child("chatList").childByAutoId().setValue(["user": currentUser?.uid, "text": textField.text, "time": ServerValue.timestamp()])
    }
    
    func read()  { //データの読み込みの関数
        //FIRDataEventTypeを.Valueにすることにより、なにかしらの変化があった時に、実行
        //今回は、childでユーザーIDを指定することで、ユーザーが投稿したデータの一つ上のchildまで指定することになる
        ref.child("RoomList").child(currentRoom.roomID).child("chatList").observe(.value, with: {(snapShots) in
            if snapShots.children.allObjects is [DataSnapshot] {
                print("snapShots.children...\(snapShots.childrenCount)") //いくつのデータがあるかプリント
                
                print("snapShot...\(snapShots)") //読み込んだデータをプリント
                
                self.snapshot = snapShots
            }
            self.reload(snapshot: self.snapshot)
        })
    }
    
    func reload(snapshot: DataSnapshot) { //読み込んだデータを分割し配列に追加
        if snapshot.exists() {
            print(snapshot)
            //FIRDataSnapshotが存在するか確認
            Array.removeAll()
            //1つになっているFIRDataSnapshotを分割し、配列に入れる
            for item in snapshot.children {
                Array.append(item as! DataSnapshot)
            }
            // ローカルのデータベースを更新
            ref.child((currentUser?.uid)!).keepSynced(true)
            //テーブルビューをリロード
            tableView.reloadData()
        }
    }
    
    func getDate(number: TimeInterval) -> String { //timestampで保存された投稿時間を年月日に変換
        let date = Date(timeIntervalSince1970: number)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //セルの数
        return Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //セルの設定
        
        let itme = Array[indexPath.row]
        //itemの中身を辞書型に変換
        let content = itme.value as! Dictionary<String, AnyObject>
        
        //xibとカスタムクラスで作成したCellのインスタンスを作成
        if content["user"] as! String == currentUser?.uid {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyTalk") as! MyTalkTableViewCell
            
            cell.label.text = String(describing: content["text"]!)

            let time = content["time"] as! TimeInterval
            print(time)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "YourTalk") as! YourTalkTableViewCell

            cell.label.text = String(describing: content["text"]!)
            let num = cell.label.text?.characters.count
            cell.view.frame = CGRect(x: 20, y: 10, width: num! * 20, height: 30)
            cell.label.frame = CGRect(x: 8, y: 5, width: num! * 20, height: 20)
            let time = content["time"] as! TimeInterval
            print(time)

            return cell
        }
    }
    
//    func textFieldShouldReturn(_ textField:UITextField) -> Bool { //Returnキー
//        //キーボードをしまう
//        textField.resignFirstResponder()
//        return false
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //tableViewにタッチするとキーボードが閉じる
//        self.view.endEditing(true)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
