//
//  ViewController.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/11/27.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

var SYSTEM_COLOR = UIColor.init(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var alertController: SPAlertController!
    
    var lookBlur: Bool = false
    
    

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionSheetTest8()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
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

    
//    func alertController() {//消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息
//        let alert = SPAlertController.alertController(withTitle: "标题", message: "消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息消息", preferredStyle: .alert, animationType: .fromBottom)
//        alert.needDialogBlur = false
//        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
//            print("点击了确定")
//        }
//        let action2 = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
//            print("------点击了取消")
//        }
//        alert.addAction(action: action1)
//        alert.addAction(action: action2)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
    
}

