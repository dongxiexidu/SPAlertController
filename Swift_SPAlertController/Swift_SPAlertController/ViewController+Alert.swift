//
//  ViewController+Alert.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/10.
//  Copyright © 2020 HeFahu. All rights reserved.
//

import UIKit

extension ViewController{
    
    
    //示例9:alert 默认动画(收缩动画)
    func alertTest1() {
        let alert = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .fromBottom)
        alert.needDialogBlur = lookBlur
        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
            print("点击了确定")
        }
        let action2 = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了取消")
        }
        // 设置第2个action的颜色
        action2.titleColor = SYSTEM_COLOR
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
    
}
