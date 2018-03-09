//
//  FriendAddViewController.swift
//  messageApp
//
//  Created by 町田千優 on 2018/03/08.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit
import Firebase

class FriendAddViewController: UIViewController {
    
    var DBRef: DatabaseReference!                 //Firebaseを使用
    
    @IBOutlet var friendIDTextFIeld: UITextField! //友だちのユーザーIDを入力するTextField

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //インスタンス生成
        DBRef = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushAdd() { //追加button
        
        
    }
    
    @IBAction func pushClose() { //キャンセルbutton
        
        self.dismiss(animated: true, completion: nil)
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
