//
//  ViewController+Attributed.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/10.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit

extension ViewController {
    // 示例16:富文本(action设置富文本)
    func attributedStringTest1() {
        let alertController = SPAlertController.alertController(withTitle: nil, message: nil, preferredStyle: .actionSheet, animationType: .default)
        let action1 = SPAlertAction.action(withTitle: nil, style: .default) { (action) in
            print("点击了拍摄")
        }
        let mainTitle1 = "拍摄"
        let subTitle1 = "照片或视频"
        let totalTitle1 = mainTitle1+"\n"+subTitle1
        let attrTitle1 = NSMutableAttributedString.init(string: totalTitle1)
        let paragraphStyle1 = NSMutableParagraphStyle.init()
        paragraphStyle1.lineSpacing = 3
        paragraphStyle1.lineBreakMode = .byWordWrapping
        paragraphStyle1.alignment = .center
        // 段落样式
        attrTitle1.addAttribute(.paragraphStyle, value: paragraphStyle1, range: .init(location: 0, length: totalTitle1.count))
        // 设置富文本子标题的字体
        attrTitle1.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange.init(location: mainTitle1.count, length: subTitle1.count+1))
        attrTitle1.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange.init(location: mainTitle1.count, length: subTitle1.count+1))
        
        action1.attributedTitle = attrTitle1
        
        
        let action2 = SPAlertAction.action(withTitle: "从手机相册选择个", style: .default) { (action) in
            print("点击了`从手机相册选择`")
        }
        let action3 = SPAlertAction.action(withTitle: nil, style: .default) { (action) in
            print("点击了'用微视拍摄'")
        }
        
        let mainTitle3 = "用微视拍摄"
        let subTitle3 = "推广"
        let totalTitle3 = mainTitle3+"\n"+subTitle3
        let attrTitle3 = NSMutableAttributedString.init(string: totalTitle3)
        let paragraphStyle3 = NSMutableParagraphStyle.init()
        paragraphStyle3.lineSpacing = 3
        paragraphStyle3.lineBreakMode = .byWordWrapping
        paragraphStyle3.alignment = .center
        // 段落样式
        attrTitle1.addAttribute(.paragraphStyle, value: paragraphStyle3, range: .init(location: 0, length: totalTitle3.count))
        // 设置富文本子标题的字体
        attrTitle3.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange.init(location: mainTitle3.count, length: subTitle3.count+1))
        attrTitle3.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange.init(location: mainTitle3.count, length: subTitle3.count+1))
        
        action3.attributedTitle = attrTitle3
        
        let action4 = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了取消")
        }
        
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        alertController.addAction(action: action3)
        alertController.addAction(action: action4)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // 示例17:富文本(头部设置富文本)
       func attributedStringTest2() {
           let alertController = SPAlertController.alertController(withTitle: "", message: "确定拨打吗？", preferredStyle: .alert, animationType: .default)
           let num = "15012345689"
           let desc = "可能是一个电话号码"
           let totalTitle = num+"\n"+desc
           let attrTitle = NSMutableAttributedString.init(string: totalTitle)
        
           // 设置富文本子标题的字体
           attrTitle.addAttribute(.foregroundColor, value: SYSTEM_COLOR, range: NSRange.init(location: 0, length: num.count))
           alertController.attributedTitle = attrTitle
           
           
           let action1 = SPAlertAction.action(withTitle: "取消",  style: .destructive) { (action) in
               print("点击了`取消`")
           }
           let action2 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
               print("点击了'确定'")
           }
           action2.titleColor = SYSTEM_COLOR
           alertController.addAction(action: action1)
           alertController.addAction(action: action2)
           self.present(alertController, animated: true, completion: nil)
       }
       
    
}
