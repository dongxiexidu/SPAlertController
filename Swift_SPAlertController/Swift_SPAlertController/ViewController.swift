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
    var sureAction: SPAlertAction!
    var phoneNumberTextField: UITextField!
    var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attributedStringTest1()
    }
}

