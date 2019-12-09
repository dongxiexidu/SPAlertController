//
//  ViewController.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/11/27.
//  Copyright © 2019 HeFahu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let alert = SPAlertController.alertController(withTitle: "标题", message: "消息", preferredStyle: .actionSheet, animationType: .fromBottom)
        let action1 = SPAlertAction.action(withTitle: "主标题", style: .default) { (action) in
            print("------")
        }
        let action2 = SPAlertAction.action(withTitle: "取消", style: .destructive) { (action) in
            print("------")
        }
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }

}

