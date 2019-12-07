//
//  SPAlertController+transitionDelegate.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/7.
//  Copyright © 2019 HeFahu. All rights reserved.
//

import UIKit

//MARK: UIViewControllerTransitioningDelegate
extension SPAlertController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SPAlertAnimation.animationIsPresenting(presenting: true)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.view.endEditing(true)
        
        return SPAlertAnimation.animationIsPresenting(presenting: false)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return SPAlertPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
}
