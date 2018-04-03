//
//  TalkRoomViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/17.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension UIColor {
    class func rgb(r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
}


class TalkRoomViewController: UIViewController {
    
    var DBRef: DatabaseReference!             //インスタンス変数
    
    var myX: Int = 240                        //自分のフキダシのX座標
    var myY: Int = 50                         //自分のフキダシのY座標
    @IBOutlet var scrollView: UIScrollView!   //フキダシを表示するScrollView
    private var myTalkView: UIView!           //自分のフキダシのView
    private var myTalkLabel: UILabel!         //自分のフキダシのLabel
    
    @IBOutlet var sendButton: UIButton!       //送信button
    @IBOutlet var textField: UITextField!     //コメントを入力するTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sendButtonを無効化
//        sendButton.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushSend() { //送信button
        
    //フキダシについて
        // myTalkImageViewを作成
        myTalkView = ViewCustom(frame: CGRect(x: myX, y: myY, width: 250, height: 30))
        
        //色・角丸・位置
        self.myTalkView.backgroundColor = UIColor.white
        self.myTalkView.layer.cornerRadius = 15
        myTalkView.layer.position = CGPoint(x: myX, y: myY)

        //myTalkImageViewをViewに追加
        self.scrollView.addSubview(myTalkView)
        
    //フキダシに表示するmyTalkLabelについて
        //myTalkLabelを作成
        myTalkLabel = UILabel(frame: CGRect(x: myX + 5, y: myY, width: 245, height: 30))
        
        //myTalkLabelの表示位置を設定
        myTalkLabel.layer.position = CGPoint(x: myX + 5, y: myY)
        
        //myTalkLabelをscrollViewに追加
        self.scrollView.addSubview(myTalkLabel)
        
        //textFieldの文字をmyTalkLabelに表示
        myTalkLabel.text = textField.text
        
        //textFieldを空白にする
        textField.text = ""
        
        //次のフキダシのためにY座標を調整
        myY += 50
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
