//
//  ViewCustom.swift
//  messageApp
//
//  Created by 町田千優 on 2018/03/08.
//  Copyright © 2018年 町田千優. All rights reserved.
//

import UIKit

@IBDesignable
class ViewCustom: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}


