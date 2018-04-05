//
//  MyTalkTableViewCell.swift
//  messageApp
//
//  Created by 町田千優 on 2018/04/04.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit

class MyTalkTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel! //textを表示するLabel
    @IBOutlet var view: UIView!   //フキダシのView

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let num = self.label.text?.characters.count
        let myX = 394 - num! * 20
        self.view.frame = CGRect(x: myX, y: 10, width: num! * 20, height: 30)
        self.label.frame = CGRect(x: 8, y: 5, width: num! * 20, height: 20)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
