//
//  Nibloadable.swift
//  FashionMall
//
//  Created by fashion on 2018/1/17.
//  Copyright © 2018年 shangZhu. All rights reserved.
//

import UIKit
protocol Nibloadable {}

// 自定义View,遵守此协议,便可以用此方法加载Nib文件
extension Nibloadable where Self : UIView{
    static func loadFromNib() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}


