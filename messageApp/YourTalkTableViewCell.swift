//
//  YourTalkTableViewCell.swift
//  messageApp
//
//  Created by 町田千優 on 2018/04/04.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit

class YourTalkTableViewCell: UITableViewCell {
    
    @IBOutlet var label: UILabel! //textを表示するLabel
    @IBOutlet var view: UIView!   //フキダシのView

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
