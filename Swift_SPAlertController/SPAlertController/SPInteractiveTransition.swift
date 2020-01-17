//
//  SPInteractiveTransition.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/16.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit
// Handles interactive transition triggered via pan gesture recognizer on dialog
class SPInteractiveTransition: UIPercentDrivenInteractiveTransition {
    // If the interactive transition was started
    var hasStarted = false

    // If the interactive transition
    var shouldFinish = false

    // The view controller containing the views
    // with attached gesture recognizers weak
     var viewController: SPAlertController?

    @objc func handlePan(_ sender: UIPanGestureRecognizer) {

        guard let vc = viewController else { return }

        guard let progress = calculateProgress(sender: sender) else { return }
        switch sender.state {
        case .began:
            hasStarted = true
            vc.dismiss(animated: true, completion: nil)
        case .changed:
            shouldFinish = progress > 0.3
            update(progress)
        case .cancelled:
            hasStarted = false
            cancel()
        case .ended:
            hasStarted = false
            completionSpeed = 0.55
            shouldFinish ? finish() : cancel()
        default:
            break
        }
    }
}

extension SPInteractiveTransition {

    /*!
     Translates the pan gesture recognizer position to the progress percentage
     - parameter sender: A UIPanGestureRecognizer
     - returns: Progress
     */
    func calculateProgress(sender: UIPanGestureRecognizer) -> CGFloat? {
        guard let vc = viewController else { return nil }

        // http://www.thorntech.com/2016/02/ios-tutorial-close-modal-dragging/
        let translation = sender.translation(in: vc.view)
        let verticalMovement: CGFloat = translation.y / vc.view.bounds.height

        var downwardMovement: Float = 0.0
        if viewController?.animationType == .fromTop && viewController?.preferredStyle == .actionSheet {
            downwardMovement = fmaxf(Float(-verticalMovement), 0.0)
        } else {
            downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        }
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        
        let progress = CGFloat(downwardMovementPercent)

        return progress
    }
}
