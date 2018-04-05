//
//  User.swift
//  messageApp
//
//  Created by 町田千優 on 2018/04/02.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit

class User { //ユーザーのクラス
    
    var uid = ""      //ユーザーID
    var chatID = ""   //チャットID
    var userName = "" //ユーザー名
    
    //初期化
    init(uid: String, chatID: String, userName: String) {
        self.uid = uid
        self.chatID = chatID
        self.userName = userName
    }
}
