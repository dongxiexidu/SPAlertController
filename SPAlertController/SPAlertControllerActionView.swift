//
//  SPAlertControllerActionView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/6.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

class SPAlertControllerActionView: UIView {
    
 
    public var afterSpacing: CGFloat = SP_LINE_WIDTH
    
    private var actionButtonConstraints = [NSLayoutConstraint]()
    private var methodAction: Selector!
    private var target: AnyObject!
    
    
    func addTarget(target: AnyObject, action: Selector) {
        self.target = target
        self.methodAction = action
    }
    //手指按下然后在按钮有效事件范围内抬起
    @objc func touchUpInside() {
        _ = target.perform(self.methodAction, with: self)
    }
    //手指按下或者手指按下后往外拽再往内拽
    @objc func touchDown(button: UIButton) {
        guard let alert = self.findAlertController() else{ return }
        
        if alert.needDialogBlur {
            // 需要毛玻璃时，只有白色带透明，毛玻璃效果才更加清澈
            button.backgroundColor = SP_SELECTED_COLOR
        } else {
            // 该颜色比'取消action'上的分割线的颜色浅一些
            button.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        }
    }
    // 手指被迫停止、手指按下后往外拽或者取消，取消的可能性:比如点击的那一刻突然来电话
    @objc func touchDragExit(button: UIButton) {
        button.backgroundColor = SP_NORMAL_COLOR
    }
    
    func findAlertController() -> SPAlertController? {
        var next = self.next
        while next != nil {
            if next is SPAlertController {
                return next as? SPAlertController
            } else {
                next = next?.next
            }
        }
        return nil
    }
    
    // 安全区域发生了改变,在这个方法里自动适配iPhoneX
    override func safeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
            self.actionButton.contentEdgeInsets = self.edgeInsetsAddEdgeInsets(i1: self.safeAreaInsets, i2: action.titleEdgeInsets)
        } else {
            // Fallback on earlier versions
        }
        
        self.setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        if self.actionButtonConstraints.count > 0 {
            NSLayoutConstraint.deactivate(self.actionButtonConstraints)
            self.actionButtonConstraints.removeAll()
        }
        
        actionButtonConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[actionButton]-0-|", options: [], metrics: nil, views: ["actionButton": actionButton]))
        actionButtonConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[actionButton]-0-|", options: [], metrics: nil, views: ["actionButton": actionButton]))
        // 按钮必须确认高度，因为其父视图及父视图的父视图乃至根视图都没有设置高度，而且必须用NSLayoutRelationEqual，如果用NSLayoutRelationGreaterThanOrEqual,虽然也能撑起父视图，但是当某个按钮的高度有所变化以后，stackView会将其余按钮按的高度同比增减
        
        // titleLabel的内容自适应的高度 55
        let labelH: CGFloat = actionButton.titleLabel?.intrinsicContentSize.height ?? 0.0
        // 按钮的上下内边距之和 0
        let topBottom_insetsSum: CGFloat = actionButton.contentEdgeInsets.top+actionButton.contentEdgeInsets.bottom
        // 文字的上下间距之和,等于SP_ACTION_HEIGHT-默认字体大小,这是为了保证文字上下有一个固定间距值，不至于使文字靠按钮太紧，,由于按钮内容默认垂直居中，所以最终的顶部或底部间距为topBottom_marginSum/2.0,这个间距，几乎等于18号字体时，最小高度为49时的上下间距 33.5
        let topBottom_marginSum: CGFloat = SP_ACTION_HEIGHT-UIFont.systemFont(ofSize: SP_ACTION_TITLE_FONTSIZE).lineHeight
        
        // 按钮高度
        let buttonH = labelH+topBottom_insetsSum+topBottom_marginSum
        
        var relation = NSLayoutConstraint.Relation.equal
        if let stackView = self.superview as? UIStackView, stackView.axis == .horizontal {
            relation = .greaterThanOrEqual
        }
        // 如果字体保持默认18号，只有一行文字时最终结果约等于SP_ACTION_HEIGHT
        let buttonHonstraint = NSLayoutConstraint.init(item: actionButton, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: buttonH)
        buttonHonstraint.priority = UILayoutPriority(rawValue: 999)
        actionButtonConstraints.append(buttonHonstraint)
        
        // 给一个最小高度，当按钮字体很小时，如果还按照上面的高度计算，高度会比较小
        let minHConstraint = NSLayoutConstraint.init(item: actionButton, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: SP_ACTION_HEIGHT+topBottom_insetsSum)
        minHConstraint.priority = UILayoutPriority.required
        self.addConstraints(actionButtonConstraints)
    }
    
    private func edgeInsetsAddEdgeInsets(i1: UIEdgeInsets, i2: UIEdgeInsets) -> UIEdgeInsets {
        var bottom: CGFloat = i1.bottom
        if bottom > 21 {// 34的高度太大，这里转为21
            bottom = 21
        }
        return .init(top: i1.top+i2.top, left: i1.left+i2.left, bottom: bottom+i2.bottom, right: i1.right+i2.right)
     }
    
    lazy var actionButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = SP_NORMAL_COLOR
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.textAlignment = .center
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.baselineAdjustment = .alignCenters
        btn.titleLabel?.minimumScaleFactor = 0.5
        btn.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        btn.addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragInside])
        btn.addTarget(self, action: #selector(touchDragExit), for: [.touchDragExit, .touchUpOutside, .touchCancel])
        self.addSubview(btn)
        return btn
    }()
    
    public var action: SPAlertAction! {
         didSet {
             self.actionButton.titleLabel?.font = action.titleFont
             if action.isEnabled == true {
                 self.actionButton.setTitleColor(action.titleColor, for: .normal)
             } else {
                 self.actionButton.setTitleColor(.lightGray, for: .normal)
             }
             
             // 注意不能赋值给按钮的titleEdgeInsets，当只有文字时，按钮的titleEdgeInsets设置top和bottom值无效
             self.actionButton.contentEdgeInsets = action.titleEdgeInsets
             self.actionButton.isEnabled = action.isEnabled
             if action.attributedTitle != nil {
                 // 这里之所以要设置按钮颜色为黑色，是因为如果外界在addAction:之后设置按钮的富文本，那么富文本的颜色在没有采用NSForegroundColorAttributeName的情况下会自动读取按钮上普通文本的颜色，在addAction:之前设置会保持默认色(黑色)，为了在addAction:前后设置富文本保持统一，这里先将按钮置为黑色，富文本就会是黑色
                 self.actionButton.setTitleColor(.black, for: .normal)
                 if action.attributedTitle!.string.contains("\n") || action.attributedTitle!.string.contains("\r") {
                     self.actionButton.titleLabel?.lineBreakMode = .byWordWrapping
                 }
                 self.actionButton.setAttributedTitle(action.attributedTitle!, for: .normal)
                 // 设置完富文本之后，还原按钮普通文本的颜色，其实这行代码加不加都不影响，只是为了让按钮普通文本的颜色保持跟action.titleColor一致
                 self.actionButton.setTitleColor(action.titleColor, for: .normal)
             } else {
                
                if let title = action.title {
                    if title.contains("\n") || title.contains("\r") {
                        self.actionButton.titleLabel?.lineBreakMode = .byWordWrapping
                    }
                    self.actionButton.setTitle(title, for: .normal)
                }
                 
             }
             self.actionButton.setImage(action.image, for: .normal)
             self.actionButton.titleEdgeInsets = .init(top: 0, left: action.imageTitleSpacing, bottom: 0, right: -action.imageTitleSpacing)
             self.actionButton.imageEdgeInsets = .init(top: 0, left: -action.imageTitleSpacing, bottom: 0, right: action.imageTitleSpacing)
         }
     }
}
