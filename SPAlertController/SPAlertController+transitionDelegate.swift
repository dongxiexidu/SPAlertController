//
//  SPAlertController+transitionDelegate.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/7.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

//FIXME: 文件名修改为`SPAlertController+transitioningDelegate`

//SPAlertController自定义转场动画,需要遵守`UIViewControllerTransitioningDelegate`,实现必要的协议
//MARK: UIViewControllerTransitioningDelegate
extension SPAlertController: UIViewControllerTransitioningDelegate {
    
    // 2.如何弹出的动画
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return SPAlertAnimation.animationIsPresenting(isPresenting: true, interactor: self.interactor)
    }
    // 3.如何dismissed的动画
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.view.endEditing(true)
        return SPAlertAnimation.animationIsPresenting(isPresenting: false, interactor: self.interactor)
    }
    // 1.返回一个自定义的UIPresentationController
    // 控制控制器跳转的类,是iOS8新增的一个API，用来控制controller之间的跳转特效，
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return SPAlertPresentationController.init(presentedViewController: presented, presenting: presenting)
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
