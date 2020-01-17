//
//  ViewController+Alert.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/10.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit

extension ViewController{
    
    
    //示例9:alert 默认动画(收缩动画)
    func alertTest1() {
        
        let alert = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .default)
        alert.needDialogBlur = lookBlur
        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
            print("点击了确定")
        }
        let action2 = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了取消")
        }
        if customBlur {
            alert.customOverlayView = CustomOverlayView()
        }
        // 设置第2个action的颜色
        action2.titleColor = SYSTEM_COLOR
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    //示例10:alert 发散动画
    func alertTest2() {
        let alert = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .expand)
        
        let action1 = SPAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        
        let action2 = SPAlertAction.action(withTitle: "抖动动画", style: .destructive) { (action) in
            // 抖动动画
            alert.shake()
        }
        action2.dismissOnTap = false
        
        let action3 = SPAlertAction.action(withTitle: "第3个", style: .default) { (action) in
            print("点击了第3个")
        }
        let action4 = SPAlertAction.action(withTitle: "第4个", style: .default) { (action) in
            print("点击了第4个")
        }
        if customBlur {
            alert.customOverlayView = CustomOverlayView()
        }
        // 设置第2个action的颜色
        action1.titleColor = SYSTEM_COLOR
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        alert.addAction(action: action3)
        alert.addAction(action: action4)
        alert.tapBackgroundViewDismiss = false
        self.present(alert, animated: true, completion: nil)
    }
    
    //示例11:alert 渐变动画
    func alertTest3() {
        let alert = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .fade)
        alert.needDialogBlur = lookBlur
        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
            print("点击了确定")
        }
        // 设置第1个action的颜色
        action1.titleColor = SYSTEM_COLOR
        let action2 = SPAlertAction.action(withTitle: "取消", style: .destructive) { (action) in
            print("点击了取消")
        }
        if customBlur {
            alert.customOverlayView = CustomOverlayView()
        }
        action2.titleColor = .red
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    //示例12:alert 垂直排列2个按钮
    func alertTest4() {
        let alert = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .expand)
        // 2个按钮时默认是水平排列，这里强制垂直排列
        alert.actionAxis = .vertical
        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
            print("点击了确定")
        }
        // 设置第1个action的颜色
        action1.titleColor = .red
        let action2 = SPAlertAction.action(withTitle: "取消", style: .destructive) { (action) in
            print("点击了取消")
        }
        if customBlur {
            alert.customOverlayView = CustomOverlayView()
        }
        action2.titleColor = SYSTEM_COLOR
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    //示例13:alert 水平排列2个以上的按钮(默认超过2个按钮是垂直排列)
    func alertTest5() {
        let alert = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .expand)
        // 2个按钮时默认是水平排列，这里强制水平排列
        alert.actionAxis = .horizontal
        let action1 = SPAlertAction.action(withTitle: "第1个", style: .default) { (action) in
            print("点击了第1个")
        }
        // 设置第1个action的颜色
        action1.titleColor = SYSTEM_COLOR
        let action2 = SPAlertAction.action(withTitle: "第2个", style: .destructive) { (action) in
            print("点击了第2个")
        }
        action2.titleColor = .magenta
        let action3 = SPAlertAction.action(withTitle: "第3个", style: .destructive) { (action) in
            print("点击了第3个")
        }
        if customBlur {
            alert.customOverlayView = CustomOverlayView()
        }
        alert.addAction(action: action1)
        alert.addAction(action: action2)
        alert.addAction(action: action3)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //示例14:alert 设置头部图标
    func alertTest6() {
        let alert = SPAlertController.alertController(withTitle: "“支付宝”的触控 ID", message: "请验证已有指纹", preferredStyle: .alert, animationType: .shrink)
        alert.image = UIImage.init(named: "zhiwen")
        let action = SPAlertAction.action(withTitle: "取消", style: .cancel) { (action) in
            print("点击了取消")
        }
        if customBlur {
            alert.customOverlayView = CustomOverlayView()
        }
        action.titleColor = SYSTEM_COLOR
        alert.addAction(action: action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //示例15:alert 含有文本输入框
    func alertTest7() {
        let alert = SPAlertController.alertController(withTitle: "我是主标题", message: "我是副标题", preferredStyle: .alert, animationType: .default)
        let action1 = SPAlertAction.action(withTitle: "确定", style: .default) { (action) in
            print("点击了确定")
        }
        action1.isEnabled = false
        self.sureAction = action1
        // 设置第1个action的颜色
        action1.titleColor = SYSTEM_COLOR
        let action2 = SPAlertAction.action(withTitle: "取消", style: .destructive) { (action) in
            print("点击了取消")
        }
        action2.titleColor = .red
        alert.addAction(action: action2)
        alert.addAction(action: action1)
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            DLog("第1个文本输入框回调")
            // 这个block只会回调一次，因此可以在这里自由定制textFiled，如设置textField的相关属性，设置代理，添加addTarget，监听通知等
            self.phoneNumberTextField = textField
            textField.placeholder = "请输入手机号码"
            textField.clearButtonMode = .always
            textField.addTarget(self, action: #selector(self.textFieldDidChanged(textField:)), for: .editingChanged)
        }
        alert.addTextFieldWithConfigurationHandler { (textField) in
            DLog("第2个文本输入框回调")
            self.passwordTextField = textField
            textField.placeholder = "请输入密码"
            textField.clearButtonMode = .always
            textField.addTarget(self, action: #selector(self.textFieldDidChanged(textField:)), for: .editingChanged)
        }
        if customBlur {
            alert.customOverlayView = CustomOverlayView()
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func textFieldDidChanged(textField: UITextField) {
        self.sureAction.isEnabled = false
        guard let phoneNumber = phoneNumberTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        if password.count > 0 && phoneNumber.count > 0 {
            self.sureAction.isEnabled = true
        }
    }
}
