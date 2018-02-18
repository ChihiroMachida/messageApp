//
//  TalkRoomViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/17.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit

class TalkRoomViewController: UIViewController {
    
    var myX: Int = 250                        //自分のフキダシのX座標
    var myY: Int = 50                         //自分のフキダシのY座標
    @IBOutlet var scrollView: UIScrollView!   //フキダシを表示するScrollView
    private var myTalkImageView: UIImageView! //自分のフキダシのImageView
    private var myTalkLabel: UILabel!         //自分のフキダシのLabel
    
    @IBOutlet var textField: UITextField!     //コメントを入力するTextField

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func pushSend() { //送信button
        
    //フキダシについて
        // myTalkImageViewを作成
        myTalkImageView = UIImageView(frame: CGRect(x: myX, y: myY, width: 250, height: 30))
        
        // 表示する画像を設定
        let myTalkImage = UIImage(named: "myTalk.png")
        
        //画像をmyTalkImageに設定
        myTalkImageView.image = myTalkImage
        
        //myTalkImageViewの表示位置を設定
        myTalkImageView.layer.position =  CGPoint(x: myX, y: myY)
        
        //myTalkImageViewをViewに追加
        self.scrollView.addSubview(myTalkImageView)
        
    //フキダシに表示するmyTalkLabelについて
        //myTalkLabelを作成
        myTalkLabel = UILabel(frame: CGRect(x: myX + 5, y: myY, width: 250, height: 30))
        
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
