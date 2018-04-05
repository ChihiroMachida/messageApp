//
//  Room.swift
//  messageApp
//
//  Created by 町田千優 on 2018/04/03.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit

class Room {
    
    var roomID = ""    //ルームID
    var chatID1 = ""   //招待した人のchatID
    var chatID2 = ""   //招待された人のchatID
    var userName1 = "" //招待した人のuserName
    var userName2 = "" //招待された人のuserName
    
    
    //初期化
    init(roomID: String, chatID1: String, chatID2: String, userName1: String, userName2: String) {
        self.roomID = roomID
        self.chatID1 = chatID1
        self.chatID2 = chatID2
        self.userName1 = userName1
        self.userName2 = userName2
    }
}
