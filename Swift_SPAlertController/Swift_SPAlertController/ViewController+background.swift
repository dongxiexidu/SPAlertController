//
//  ViewController+background.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/14.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit
extension ViewController {
    
    func background(appearanceStyle: SPBackgroundViewAppearanceStyle) {
        
        let alertController = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .actionSheet)
        alertController.needDialogBlur = lookBlur
        let action1 = SPAlertAction.action(withTitle: "Default", style: .default) { (action) in
            print("点击了Default")
        }
        let action2 = SPAlertAction.action(withTitle: "Destructive", style: .destructive) { (action) in
            print("点击了Destructive")
        }
        let action3 = SPAlertAction.action(withTitle: "Cancel", style: .cancel) { (action) in
            print("点击了Cancel------")
        }
        
        alertController.addAction(action: action1)
        alertController.addAction(action: action3)
        alertController.addAction(action: action2)
        if customBlur {
            alertController.customOverlayView = CustomOverlayView()
        } else {
            if appearanceStyle == .translucent {
                // 0.5是半透明(默认),设置1为不透明,0为全透明
                alertController.setBackgroundViewAppearanceStyle(appearanceStyle, alpha: 0.5)
            } else {
                alertController.setBackgroundViewAppearanceStyle(appearanceStyle, alpha: 1.0)
            }
        }
        self.present(alertController, animated: true, completion: nil)
        
    }
}
