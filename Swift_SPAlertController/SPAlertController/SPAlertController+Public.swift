//
//  SPAlertController+Public.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/9.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

public extension SPAlertController{
    
    class func alertController(withTitle title: String?,
                               message: String?,
                               preferredStyle: SPAlertControllerStyle,
                               panGestureDismissal: Bool = true)->SPAlertController {
        let alertVC = SPAlertController.init(title: title, message: message, customAlertView: nil, customHeaderView: nil, customActionSequenceView: nil, componentView: nil, preferredStyle: preferredStyle, animationType: SPAlertAnimationType.default, panGestureDismissal: panGestureDismissal)
        return alertVC
    }
    
    class func alertController(withTitle title: String?,
                               message: String?,
                               preferredStyle: SPAlertControllerStyle,
                               animationType: SPAlertAnimationType,
                               panGestureDismissal: Bool = true)
        ->SPAlertController {
        let alertVC = SPAlertController.init(title: title, message: message, customAlertView: nil, customHeaderView: nil, customActionSequenceView: nil, componentView: nil, preferredStyle: preferredStyle, animationType: animationType, panGestureDismissal: panGestureDismissal)
        return alertVC
    }
    
    /// 创建控制器(自定义整个对话框)
    /// - Parameters:
    ///   - customAlertView: 整个对话框的自定义view
    ///   - preferredStyle: 对话框样式
    ///   - animationType: 动画类型
    class func alertController(withCustomAlertView customAlertView: UIView,
                               preferredStyle: SPAlertControllerStyle,
                               animationType: SPAlertAnimationType,
                               panGestureDismissal: Bool = true)
           ->SPAlertController {
            
        let alertVC = SPAlertController.init(title: nil, message: nil, customAlertView: customAlertView, customHeaderView: nil, customActionSequenceView: nil, componentView: nil, preferredStyle: preferredStyle, animationType: animationType, panGestureDismissal: panGestureDismissal)
        return alertVC
    }
    
    /// 创建控制器(自定义对话框的头部)
    /// - Parameters:
    ///   - customHeaderView: 头部自定义view
    ///   - preferredStyle: 对话框样式
    ///   - animationType: 动画类型
    class func alertController(withCustomHeaderView customHeaderView: UIView,
                               preferredStyle: SPAlertControllerStyle,
                               animationType: SPAlertAnimationType,
                               panGestureDismissal: Bool = true)
        ->SPAlertController {
            
        let alertVC = SPAlertController.init(title: nil, message: nil, customAlertView: nil, customHeaderView: customHeaderView, customActionSequenceView: nil, componentView: nil, preferredStyle: preferredStyle, animationType: animationType, panGestureDismissal: panGestureDismissal)
        return alertVC
    }
    
    /// 创建控制器(自定义对话框的action部分)
    /// - Parameters:
    ///   - customActionSequenceView: 自定义对话框的action部分
    ///   - preferredStyle: 对话框样式
    ///   - animationType: 动画类型
    class func alertController(withCustomActionSequenceView customActionSequenceView: UIView,
                               preferredStyle: SPAlertControllerStyle,
                               animationType: SPAlertAnimationType,
                               panGestureDismissal: Bool = true)
           ->SPAlertController {
            
        let alertVC = SPAlertController.init(title: nil, message: nil, customAlertView: nil, customHeaderView: nil, customActionSequenceView: customActionSequenceView, componentView: nil, preferredStyle: preferredStyle, animationType: animationType, panGestureDismissal: panGestureDismissal)
        return alertVC
    }
    
    /// 创建控制器(自定义对话框的action部分)
    /// - Parameters:
    ///   - customActionSequenceView: action部分的自定义view
    ///   - title: 大标题
    ///   - message: 副标题
    ///   - preferredStyle: 对话框样式
    ///   - animationType: 动画类型
    class func alertController(withCustomActionSequenceView customActionSequenceView: UIView,
                               title: String,
                               message: String,
                               preferredStyle: SPAlertControllerStyle,
                               animationType: SPAlertAnimationType,
                               panGestureDismissal: Bool = true) -> SPAlertController{
        
        let alertVC = SPAlertController.init(title: title, message: message, customAlertView: nil, customHeaderView: nil, customActionSequenceView: customActionSequenceView, componentView: nil, preferredStyle: preferredStyle, animationType: animationType, panGestureDismissal: panGestureDismissal)
        return alertVC
    }

    /// 设置alert样式下的偏移量,动画为NO则跟属性offsetForAlert等效
    func setOffsetForAlert(_ offsetForAlert: CGPoint, animated: Bool) {
        self.offsetForAlert = offsetForAlert
        self.isForceOffset = true
        self.makeViewOffsetWithAnimated(animated)
    }

    
    ///设置action与下一个action之间的间距, action仅限于非取消样式，必须在'-addAction:'之后设置，iOS11或iOS11以上才能使用
    @objc @available(iOS 11.0, *)
    func setCustomSpacing(spacing: CGFloat, aferAction action: SPAlertAction?) {
        guard let action = action else { return }
        if action.style == .cancel {
            print("*** warning in -[SPAlertController setCustomSpacing:afterAction:]: 'the -action must not be a action with SPAlertActionStyleCancel style'")
        } else if self.otherActions.contains(action) == false {
            print("*** warning in -[SPAlertController setCustomSpacing:afterAction:]: 'the -action must be contained in the -actions array, not a action with SPAlertActionStyleCancel style'")
        } else {
            var index: Int = 0
            for item in self.otherActions{
                if item == action  {
                    break
                }
                index += 1
            }
            actionSequenceView?.setCustomSpacing(spacing: spacing, afterActionIndex: index)
        }
    }
    @available(iOS 11.0, *)
    func customSpacing(aferAction action: SPAlertAction) -> CGFloat {
        if self.otherActions.contains(action) == true {
            var index: Int = 0
            for item in self.otherActions{
                if item == action  {
                    break
                }
                index += 1
            }
            return actionSequenceView!.customSpacingAfterActionIndex(index)
        }
        return 0.0
    }
    
    // 设置蒙层的外观样式,可通过alpha调整透明度
    func setBackgroundViewAppearanceStyle(_ style: SPBackgroundViewAppearanceStyle, alpha: CGFloat) {
        backgroundViewAppearanceStyle = style
        backgroundViewAlpha = alpha
    }
    //更新自定义view的size，比如屏幕旋转，自定义view的大小发生了改变，可通过该方法更新size
    func updateCustomViewSize(size: CGSize) {
        customViewSize = size
        layoutAlertControllerView()
        layoutChildViews()
    }
    
    // 插入一个组件view，位置处于头部和action部分之间，要求头部和action部分同时存在
    func insertComponentView(_ componentView: UIView) {
        self._componentView = componentView
    }
    // 对自己创建的alertControllerView布局，在这个方法里，self.view才有父视图，有父视图才能改变其约束
    func layoutAlertControllerView() {
        if alertControllerView.superview == nil {
            return
        }
        
        if let arr = alertControllerViewConstraints {
            NSLayoutConstraint.deactivate(arr)
            alertControllerViewConstraints = nil
        }
        if preferredStyle == .alert {
            layoutAlertControllerViewForAlertStyle()
        } else {
            layoutAlertControllerViewForActionSheetStyle()
        }
    }
    
    func addAction(action: SPAlertAction) {
        //FIXME:actions 要修改为只读属性,防止外界修改actions
        actions.append(action)
        // alert样式不论是否为取消样式的按钮，都直接按顺序添加
        if preferredStyle == .alert {
            if action.style != .cancel {
                //alert样式不论是否为取消样式的按钮，都直接按顺序添加
                otherActions.append(action)
            }
            actionSequenceView?.addAction(action: action)
        } else { // actionSheet样式
            if action.style == .cancel {
                actionSequenceView?.addCancelAction(action: action)
            } else {
                otherActions.append(action)
                actionSequenceView?.addAction(action: action)
            }
        }
        
        // 如果为false,说明外界没有设置actionAxis，此时按照默认方式排列
        if !self.isForceLayout {
            // 本框架任何一处都不允许调用actionAxis的setter方法，
            // 如果调用了则无法判断是外界调用还是内部调用
            if preferredStyle == .alert {
                if actions.count > 2 {//action的个数大于2时垂直排
                    _actionAxis = .vertical
                } else {
                    _actionAxis = .horizontal
                }
            } else {// actionSheet样式下默认垂直排列
                _actionAxis = .vertical
            }
        }
        updateActionAxis()
        
        
        // 这个block是保证外界在添加action之后再设置action属性时依然生效；
        // 当使用时在addAction之后再设置action的属性时，会回调这个block
        action.propertyChangedClosure = { [weak self] (action: SPAlertAction,needUpdateConstraints: Bool)  in
            
            guard let `self` = self else { return }
            if self.preferredStyle == .alert {
                // alert样式下：arrangedSubviews数组和actions是对应的
                var index: Int = 0
                for (i, item) in self.actions.enumerated() {
                    if item == action {
                        index = i
                        break
                    }
                }
                if let actionView = self.actionSequenceView?.stackView.arrangedSubviews[index] as?  SPAlertControllerActionView {
                    actionView.action = action
                }
                if let _ = self.presentationController{
                    // 文字显示不全处理
                    self.handleIncompleteTextDisplay()
                }
                
            } else {
                if action.style == .cancel {
                    // cancelView中只有唯一的一个actionView
                    if let actionView = self.actionSequenceView?.cancelView.subviews.last as? SPAlertControllerActionView {
                        // 这个判断可以不加，加判断是防止有一天改动框架不小心在cancelView中加了新的view产生安全隐患
                        actionView.action = action
                    }
                    
                } else {
                    // actionSheet样式下：arrangedSubviews数组和otherActions是对应的
                    var index: Int = 0
                    for (i, item) in self.otherActions.enumerated() {
                        if item == action {
                            index = i
                            break
                        }
                    }
                    if let actionView = self.actionSequenceView?.stackView.arrangedSubviews[index] as?  SPAlertControllerActionView {
                        actionView.action = action
                    }
                    
                }
            }
            if let _ = self.presentationController, needUpdateConstraints == true {
                //如果在present完成后的某个时刻再去设置action的属性，字体等改变需要更新布局
                self.actionSequenceView?.setNeedsUpdateConstraints()
            }
        }
        
    }
    
    
    /* 添加文本输入框
    * 一旦添加后就会回调一次(仅回调一次,因此可以在这个block块里面自由定制textFiled,
    * 如设置textField的属性,设置代理,添加addTarget,监听通知等)
    */
    func addTextFieldWithConfigurationHandler(handler: ((UITextField)->Void)?) {
        assert(preferredStyle == .alert, "SPAlertController does not allow 'addTextFieldWithConfigurationHandler:' to be called in the style of SPAlertControllerStyleActionSheet")
        
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .white
        // 系统的UITextBorderStyleLine样式线条过于黑，所以自己设置
        textField.layer.borderWidth = SP_LINE_WIDTH
        textField.layer.borderColor = UIColor.gray.cgColor
        // 在左边设置一张view，充当光标左边的间距，否则光标紧贴textField不美观
        textField.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 5, height: 0))
        textField.leftView?.isUserInteractionEnabled = false
        textField.leftViewMode = .always
        // 去掉textField键盘上部的联想条
        textField.autocorrectionType = .no
        
        textField.addTarget(self, action: #selector(textFieldDidEndOnExit(textField:)), for: .editingDidEndOnExit)
        
        //FIXME:self.textFields.mutableCopy
        self.textFields.append(textField)
        headerView!.addTextField(textField: textField)
        handler?(textField)
    }
    
    func shake() {
        alertControllerView.pv_shake()
    }
}


internal extension UIView {

    /// The key for the fade animation
    var fadeKey: String { return "FadeAnimation" }
    var shakeKey: String { return "ShakeAnimation" }


    func pv_layoutIfNeededAnimated(duration: CFTimeInterval = 0.08) {
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(), animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // As found at https://gist.github.com/mourad-brahim/cf0bfe9bec5f33a6ea66#file-uiview-animations-swift-L9
    // Slightly modified
    func pv_shake() {
        layer.removeAnimation(forKey: shakeKey)
        let vals: [Double] = [-2, 2, -2, 2, 0]
        
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        translation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        translation.values = vals
        
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.values = vals.map { (degrees: Double) in
            let radians: Double = (Double.pi * degrees) / 180.0
            return radians
        }
        
        let shakeGroup: CAAnimationGroup = CAAnimationGroup()
        shakeGroup.animations = [translation, rotation]
        shakeGroup.duration = 0.3
        self.layer.add(shakeGroup, forKey: shakeKey)
    }
}

