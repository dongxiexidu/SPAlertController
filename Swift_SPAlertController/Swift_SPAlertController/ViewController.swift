//
//  ViewController.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/11/27.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        sheetController()
//        alertController()
//        customAlert()
    }

    
    func customAlert() {
        let customV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        customV.backgroundColor = .red

        let alert = SPAlertController.alertController(withCustomHeaderView: customV, preferredStyle: .alert, animationType: .expand)
        alert.needDialogBlur = false
        
//        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
//            print("点击了确定")
//        }
//        let action2 = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
//            print("------点击了取消")
//        }
//        alert.addAction(action: action1)
//        alert.addAction(action: action2)
        
        alert.updateCustomViewSize(size: customV.bounds.size)
        self.present(alert, animated: true, completion: nil)
    }

    
    func alertController() {//消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息
        let alert = SPAlertController.alertController(withTitle: "标题", message: "消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息", preferredStyle: .alert, animationType: .fromBottom)
        alert.needDialogBlur = false
        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
            print("点击了确定")
        }
        let action2 = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("------点击了取消")
        }
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    func sheetController() { //消息消息消息消息消息消息消息消息消息消息消息消息消息
        let alert = SPAlertController.alertController(withTitle: "标题标题标题标题标题", message: "消息消息", preferredStyle: .actionSheet)
        alert.needDialogBlur = false
        let action1 = SPAlertAction.action(withTitle: "Default", style: .default) { (action) in
            print("点击了确定")
        }
        let action2 = SPAlertAction.action(withTitle: "Destructive", style: .destructive) { (action) in
            print("------Destructive")
        }
        let action3 = SPAlertAction.action(withTitle: "Cancel", style: .cancel) { (action) in
            print("点击了Cancel------")
        }
        let action4 = SPAlertAction.action(withTitle: "Destructive", style: .default) { (action) in
            print("------Destructive")
        }
        alert.addAction(action: action1)
        alert.addAction(action: action3)
        alert.addAction(action: action2)
        alert.addAction(action: action4)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

