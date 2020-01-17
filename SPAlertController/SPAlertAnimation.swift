//
//  SPAlertAnimation.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/6.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

class SPAlertAnimation: NSObject {
    
    var interactor: SPInteractiveTransition
    private var presenting: Bool = false
    
    public class func animationIsPresenting(isPresenting: Bool, interactor: SPInteractiveTransition) -> SPAlertAnimation{
        let alertAnimation = SPAlertAnimation.init(isPresenting: isPresenting, interactor: interactor)
        return alertAnimation
    }
    
    private init(isPresenting: Bool, interactor: SPInteractiveTransition) {
        self.interactor = interactor
        super.init()
        self.presenting = isPresenting
    }
    
}

extension SPAlertAnimation: UIViewControllerAnimatedTransitioning{
    
    // 1.动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.25
    }
    // 2.如何执行动画
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting == true {
            self.presentAnimationTransition(transitionContext: transitionContext)
        } else { // 退出动画
            self.dismissAnimationTransition(transitionContext: transitionContext)
        }
    }
}

extension SPAlertAnimation {
    
    private func presentAnimationTransition(transitionContext: UIViewControllerContextTransitioning){
        let alertController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        //let alert = alertController as! SPAlertController
        guard let alert = alertController as? SPAlertController else { return }
        
        switch alert.animationType {
        case .fromBottom:
            self.raiseUpWhenPresent(forController: alert, transition: transitionContext)
        case .fromRight:
            self.fromRightWhenPresent(forController: alert, transition: transitionContext)
        case .fromTop:
            self.dropDownWhenPresent(forController: alert, transition: transitionContext)
        case .fromLeft:
            self.fromLeftWhenPresent(forController: alert, transition: transitionContext)
        case .fade:
            self.alphaWhenPresent(forController: alert, transition: transitionContext)
        case .expand:
            self.expandWhenPresent(forController: alert, transition: transitionContext)
        case .shrink:
            self.shrinkWhenPresent(forController: alert, transition: transitionContext)
        case .none:
            self.noneWhenPresent(forController: alert, transition: transitionContext)
        default:
            self.noneWhenPresent(forController: alert, transition: transitionContext)
            break
        }
    }
    private func dismissAnimationTransition(transitionContext: UIViewControllerContextTransitioning){
       
        let alertController = transitionContext.viewController(forKey: .from)
        guard let alert = alertController as? SPAlertController else { return }
        
        if interactor.hasStarted || interactor.shouldFinish {
            self.dismissInteractive(forController: alert, transition: transitionContext)
            return
        }
        
        switch alert.animationType {
        case .fromBottom:
            self.dismissCorrespondingRaiseUp(forController: alert, transition: transitionContext)
        case .fromRight:
            self.dismissCorrespondingFromRight(forController: alert, transition: transitionContext)
        case .fromTop:
            self.dismissCorrespondingDropDown(forController: alert, transition: transitionContext)
        case .fromLeft:
            self.dismissCorrespondingFromLeft(forController: alert, transition: transitionContext)
        case .fade:
            self.dismissCorrespondingAlpha(forController: alert, transition: transitionContext)
        case .expand:
            self.dismissCorrespondingExpand(forController: alert, transition: transitionContext)
        case .shrink:
            self.dismissCorrespondingShrink(forController: alert, transition: transitionContext)
        case .none:
            self.dismissCorrespondingNone(forController: alert, transition: transitionContext)
        default:
            self.dismissInteractive(forController: alert, transition: transitionContext)
            break
        }
    }
    
    
    // 从底部弹出的present动画
    private func raiseUpWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用SPAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.y = SP_SCREEN_HEIGHT
        alertController.view.frame = controlViewFrame
        // (0.0, 667.0, 375.0, 0.0)
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.y = SP_SCREEN_HEIGHT-controlViewFrame.size.height
            } else {
                controlViewFrame.origin.y = (SP_SCREEN_HEIGHT-controlViewFrame.size.height) / 2.0
                self.offSetCenter(alertController: alertController)
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
        
    }
    // 从底部弹出对应的dismiss动画
    private func dismissCorrespondingRaiseUp(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.y = SP_SCREEN_HEIGHT
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
        })
    }
    // 从右边弹出的present动画
    private func fromRightWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用SPAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.x = SP_SCREEN_WIDTH
        alertController.view.frame = controlViewFrame
        
        if alertController.preferredStyle == .alert {
            self.offSetCenter(alertController: alertController)
        }
        
        let duration = self.transitionDuration(using: transition)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.x = SP_SCREEN_WIDTH-controlViewFrame.size.width
            } else {
                controlViewFrame.origin.x = (SP_SCREEN_WIDTH-controlViewFrame.size.width) / 2.0
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 从右边弹出对应的dismiss动画
    private func dismissCorrespondingFromRight(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.x = SP_SCREEN_WIDTH
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
        })
    }
    // 从左边弹出的present动画
    private func fromLeftWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用SPAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.x = -controlViewFrame.size.width
        alertController.view.frame = controlViewFrame
        
        if alertController.preferredStyle == .alert {
            self.offSetCenter(alertController: alertController)
        }
        
        let duration = self.transitionDuration(using: transition)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.x = 0
            } else {
                controlViewFrame.origin.x = (SP_SCREEN_WIDTH-controlViewFrame.size.width) / 2.0
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 从左边弹出对应的dismiss动画
    private func dismissCorrespondingFromLeft(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.x = -controlViewFrame.size.width
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
        })
    }
    // 从顶部弹出的present动画
    private func dropDownWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用SPAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        // 这3行代码不能放在layoutIfNeeded()之前，如果放在之前，
        // layoutIfNeeded()强制布局后会将以下设置的frame覆盖
        var controlViewFrame = alertController.view.frame
        controlViewFrame.origin.y = -controlViewFrame.size.height
        alertController.view.frame = controlViewFrame
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            var controlViewFrame = alertController.view.frame
            if alertController.preferredStyle == .actionSheet {
                controlViewFrame.origin.y = 0
            } else {
                controlViewFrame.origin.y = (SP_SCREEN_HEIGHT-controlViewFrame.size.height) / 2.0
                self.offSetCenter(alertController: alertController)
            }
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 从顶部弹出对应的dismiss动画
    private func dismissCorrespondingDropDown(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, animations: {
            var controlViewFrame = alertController.view.frame
           
            controlViewFrame.origin.y = -controlViewFrame.size.height
            alertController.view.frame = controlViewFrame
        }, completion: { finished in
            transition.completeTransition(finished)
        })
    }
    
    // alpha值从0到1变化的present动画
    private func alphaWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用SPAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        alertController.view.alpha = 0
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.offSetCenter(alertController: alertController)
            alertController.view.alpha = 1.0
        }, completion: { finished in
            
            transition.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // alpha值从0到1变化对应的的dismiss动画
    private func dismissCorrespondingAlpha(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, animations: {
            alertController.view.alpha = 0.0
        }, completion: { finished in
            transition.completeTransition(finished)
        })
    }
    
    // 发散的prensent动画
    private func expandWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用SPAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        alertController.view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        alertController.view.alpha = 0.0
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.offSetCenter(alertController: alertController)
            alertController.view.alpha = 1.0
        }, completion: { finished in
            
            transition.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 发散对应的dismiss动画
    private func dismissCorrespondingExpand(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, animations: {
            alertController.view.transform = .identity
            alertController.view.alpha = 0.0
        }, completion: { finished in
            transition.completeTransition(finished)
        })
    }
    
    // 收缩的present动画
    private func shrinkWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        
        // 标记需要刷新布局
        containerView.setNeedsLayout()
        // 在有标记刷新布局的情况下立即布局，这行代码很重要，
        // 第一：立即布局会立即调用SPAlertController的viewWillLayoutSubviews的方法，
        // 第二：立即布局后可以获取到alertController.view的frame
        containerView.layoutIfNeeded()
        
        alertController.view.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
        alertController.view.alpha = 0.0
        
        let duration = self.transitionDuration(using: transition)
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            
            self.offSetCenter(alertController: alertController)
            alertController.view.transform = .identity
            alertController.view.alpha = 1.0
        }, completion: { finished in
            
            transition.completeTransition(finished)
            alertController.layoutAlertControllerView()
        })
    }
    // 收缩对应的的dismiss动画
    private func dismissCorrespondingShrink(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        // 与发散对应的dismiss动画相同
        self.dismissCorrespondingExpand(forController: alertController, transition: transition)
    }
    
    // 无动画
    private func noneWhenPresent(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        let containerView = transition.containerView
        // 将alertController的view添加到containerView上
        containerView.addSubview(alertController.view)
        
        transition.completeTransition(transition.isAnimated)
    }
    
    // 无动画
    private func dismissCorrespondingNone(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        transition.completeTransition(transition.isAnimated)
    }
    
    // 手势退出
    private func dismissInteractive(forController alertController: SPAlertController,
                                         transition: UIViewControllerContextTransitioning) {
        
        UIView.animate(withDuration: 0.32, delay: 0.0, options: [.beginFromCurrentState], animations: { 
            var offsetHeight: CGFloat = alertController.view.bounds.size.height
            if offsetHeight < 200 {
                offsetHeight = 200
            }
            offsetHeight = -offsetHeight
            if alertController.animationType == .fromTop && alertController.preferredStyle == .actionSheet {
                offsetHeight = -offsetHeight
            }
            if alertController.preferredStyle == .alert {
                offsetHeight = -(SP_SCREEN_HEIGHT-alertController.view.bounds.size.height)/2
            }
            alertController.view.bounds.origin = CGPoint(x: 0, y: offsetHeight)
            alertController.view.alpha = 0.0
        }, completion: { _ in
            transition.completeTransition(!transition.transitionWasCancelled)
        })
    }
    
    private func offSetCenter(alertController: SPAlertController) {
        if !alertController.offsetForAlert.equalTo(.zero) {
            var controlViewCenter: CGPoint = alertController.view.center
            controlViewCenter.x = SP_SCREEN_WIDTH/2 + alertController.offsetForAlert.x
            controlViewCenter.y = SP_SCREEN_HEIGHT/2 + alertController.offsetForAlert.y
            alertController.view.center = controlViewCenter
        }
    }
}
