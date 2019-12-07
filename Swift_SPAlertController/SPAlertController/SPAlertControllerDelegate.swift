//
//  SPAlertControllerDelegate.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/6.
//  Copyright © 2019 HeFahu. All rights reserved.
//

import Foundation


protocol SPAlertControllerDelegate: NSObject {
    
}

extension SPAlertControllerDelegate {
    
    /// 将要present
    func willPresentAlertController(alertController: SPAlertController) {
        
    }
    /// 已经present
    func didPresentAlertController(alertController: SPAlertController) {
        
    }
    /// 将要dismiss
    func willDismissAlertController(alertController: SPAlertController) {
        
    }
    /// 已经dismiss
    func didDismissAlertController(alertController: SPAlertController) {
        
    }
}
