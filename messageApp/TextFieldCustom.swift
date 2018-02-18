//
//  TextFieldCustom.swift
//  messageApp
//
//  Created by 町田千優 on 2018/02/18.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit

class TextFieldCustom: UITextField {
    
    @IBInspectable var lineHeight: CGFloat = 1.0
    @IBInspectable var lineColor: UIColor = .lightGray
    
    override func draw(_ rect: CGRect) {
        
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - lineHeight, width: self.frame.width, height: lineHeight)
        border.backgroundColor = lineColor.cgColor
        layer.addSublayer(border)
        
        super.draw(rect)
    }
}
