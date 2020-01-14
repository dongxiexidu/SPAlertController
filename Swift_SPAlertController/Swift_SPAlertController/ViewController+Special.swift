//
//  ViewController+Special.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/14.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit

extension ViewController {

    // 示例26:当按钮过多时
    func specialtest1() {
        let alertController = SPAlertController.alertController(withTitle: "请滑动查看更多内容", message: "谢谢", preferredStyle: .actionSheet, animationType: .default)
        alertController.minDistanceToEdges = 100
        for i in 0..<15 {
            let action = SPAlertAction.action(withTitle: "第\(i)个", style: .default) { (action) in
                print("点击了第\(i)个")
            }
            alertController.addAction(action: action)
        }
        let cancelAction = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了cancel")
        }
        alertController.addAction(action: cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // 示例27:当文字和按钮同时过多时，文字占据更多位置
    func specialtest2() {
        let alertController = SPAlertController.alertController(withTitle: "请滑动查看更多内容", message: "谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢谢", preferredStyle: .actionSheet, animationType: .default)
       // alertController.minDistanceToEdges = 100
        for i in 0..<5 {
            let action = SPAlertAction.action(withTitle: "第\(i)个", style: .default) { (action) in
                print("点击了第\(i)个")
            }
            alertController.addAction(action: action)
        }
        let cancelAction = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了cancel")
        }
        alertController.addAction(action: cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 示例28:action上的文字过长（垂直）
    func specialtest4() {
        let alertController = SPAlertController.alertController(withTitle: "提示", message: "SPAlertControllerStyleAlert样式下2个按钮默认是水平排列，如果存在按钮文字过长，则自动会切换为垂直排列，除非外界设置了'actionAxis'。如果垂直排列后文字依然过长，则会压缩字体适应宽度，压缩到0.5倍封顶", preferredStyle: .alert, animationType: .default)
        alertController.messageColor = .red
        let action1 = SPAlertAction.action(withTitle: "明白", style: .default) { (action) in
            print("点击了明白")
        }
        let action2 = SPAlertAction.action(withTitle: "我的文字太长了，所以垂直排列显示更多文字，垂直后依然显示不全则压缩字体，压缩到0.5倍封顶", style: .default) { (action) in
            print("点击了'上九天揽月，下五洋捉鳖")
        }
        action2.titleColor = SYSTEM_COLOR
        alertController.addAction(action: action1)
        alertController.addAction(action: action2)
        self.present(alertController, animated: true, completion: nil)
    }
    // 示例29:action上的文字过长（水平）
     func specialtest5() {
         let alertController = SPAlertController.alertController(withTitle: "提示", message: "SPAlertControllerStyleAlert样式下2个按钮默认是水平排列，如果存在按钮文字过长，则自动会切换为垂直排列，本例之所以为水平排列，是因为外界设置了'actionAxis'为UILayoutConstraintAxisHorizontal", preferredStyle: .alert, animationType: .default)
         alertController.messageColor = .red
        alertController.actionAxis = .horizontal
         let action1 = SPAlertAction.action(withTitle: "明白", style: .default) { (action) in
             print("点击了明白")
         }
         let action2 = SPAlertAction.action(withTitle: "我的文字太长了，会压缩字体", style: .default) { (action) in
             print("点击了'我的文字太长了，会压缩字体")
         }
         action2.titleColor = SYSTEM_COLOR
         alertController.addAction(action: action1)
         alertController.addAction(action: action2)
         self.present(alertController, animated: true, completion: nil)
     }
}
