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
    }

    
    func customAlert() {
        let customV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        customV.backgroundColor = .red

        let alert = SPAlertController.alertController(withCustomHeaderView: customV, preferredStyle: .alert, animationType: .expand)
        alert.needDialogBlur = true
        alert.updateCustomViewSize(size: customV.bounds.size)
        self.present(alert, animated: true, completion: nil)
    }

    
    func alertController() {
        let alert = SPAlertController.alertController(withTitle: "标题", message: "消息", preferredStyle: .alert, animationType: .shrink)
       // alert.needDialogBlur = true
        let action1 = SPAlertAction.action(withTitle: "主标题", style: .default) { (action) in
            print("点击了确定")
        }
        let action2 = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("------点击了取消")
        }
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    func sheetController() {
        let alert = SPAlertController.alertController(withTitle: "标题", message: "消息", preferredStyle: .actionSheet)
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
        alert.addAction(action: action1)
        alert.addAction(action: action3)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

