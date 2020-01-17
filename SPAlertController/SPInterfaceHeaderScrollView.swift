//
//  SPInterfaceHeaderScrollView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/6.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

class SPInterfaceHeaderScrollView: UIScrollView {

    public var imageLimitSize: CGSize = .zero
    private var textFieldsArray = [UITextField]()
    public var contentEdgeInsets: UIEdgeInsets = .init(top: 20, left: 15, bottom: 20, right: 15)
    public var headerViewSafeAreaDidChangeClosure: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - lazy var
    
    lazy var textFieldView: UIStackView = {
        let stackV = UIStackView.init()
        stackV.translatesAutoresizingMaskIntoConstraints = false
        stackV.distribution = .fillEqually
        stackV.axis = .vertical
        if self.textFieldsArray.count > 0 {
            self.contentView.addSubview(stackV)
        }
        return stackV
    }()
    
    lazy var contentView: UIView = {
        let contentV = UIView()
        contentV.backgroundColor = .white
        contentV.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentV)
        return contentV
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
      //  label.backgroundColor = .cyan
        label.font = UIFont.boldSystemFont(ofSize: SP_ACTION_TITLE_FONTSIZE)
        label.textAlignment = .center
        label.textColor = .black
        label.text = ""
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        return label
    }()
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: SP_ACTION_TITLE_FONTSIZE)
        label.textAlignment = .center
        label.text = ""
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(label)
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.insertSubview(imgV, at: 0)
        return imgV
    }()
}

extension SPInterfaceHeaderScrollView {
    
    func addTextField(textField: UITextField) {
        self.textFieldsArray.append(textField)
        // 将textView添加到self.textFieldView中的布局队列中，
        // UIStackView会根据设置的属性自动布局
        self.textFieldView.addArrangedSubview(textField)
        // 由于self.textFieldView是没有高度的，它的高度由子控件撑起，
        // 所以子控件必须要有高度
        let heightConstraint = NSLayoutConstraint.init(item: textField, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 25.0)
        heightConstraint.isActive = true
        // 当一个自定义view的某个属性发生改变，并且可能影响到constraint时，
        // 需要调用此方法去标记constraints需要在未来的某个点更新，
        // 系统然后调用updateConstraints
        self.setNeedsUpdateConstraints()
    }
    
    // 监听安全内边距的改变
    override func safeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.safeAreaInsetsDidChange()
            
            let safeTop = safeAreaInsets.top < 20 ? 20 : safeAreaInsets.top+10
            let safeLeft = safeAreaInsets.left < 15 ? 15 : safeAreaInsets.left
            let safeBottom = safeAreaInsets.bottom < 20 ? 20 : safeAreaInsets.bottom+6
            let safeRight = safeAreaInsets.right < 15 ? 15 : safeAreaInsets.right
            
            contentEdgeInsets = .init(top: safeTop, left: safeLeft, bottom: safeBottom, right: safeRight)
        } else {
            // Fallback on earlier versions
        }
        // 这个block，主要是更新Label的最大预估宽度
        self.headerViewSafeAreaDidChangeClosure?()
        self.setNeedsUpdateConstraints()
    }
    
    // 自定义view应该重写此方法在其中建立constraints
    override func updateConstraints() {
        super.updateConstraints()
        
        // 先移除旧约束，再添加新约束
        NSLayoutConstraint.deactivate(self.constraints)
        NSLayoutConstraint.deactivate(contentView.constraints)
        
        // 对contentView布局
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|", options: [], metrics: nil, views: ["contentView": contentView]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|", options: [], metrics: nil, views: ["contentView": contentView]))
        let widthConstraint = NSLayoutConstraint.init(item: contentView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0)
        widthConstraint.isActive = true
        
        let equalHeightConstraint = NSLayoutConstraint.init(item: contentView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0)
        // 优先级不能最高， 最顶层的父view有高度限制，
        // 如果子控件撑起后的高度大于限制高度，则scrollView滑动查看全部内容
        equalHeightConstraint.priority = UILayoutPriority(rawValue: 998.0)
        equalHeightConstraint.isActive = true
        
        let leftMargin = contentEdgeInsets.left
        let rightMargin = contentEdgeInsets.right
        let topMargin = contentEdgeInsets.top
        let bottomMargin = contentEdgeInsets.bottom
        
        // 对iconView布局
        if let image = imageView.image {
            var imageViewConstraints = [NSLayoutConstraint]()
            let width = min(image.size.width, imageLimitSize.width)
            let height = min(image.size.height, imageLimitSize.height)
            
            imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: width))
            imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: height))
            imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1.0, constant: 0))
            imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: topMargin))
            
            if titleLabel.text!.count > 0 || titleLabel.attributedText != nil {
                imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: titleLabel, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: -17))
            } else if messageLabel.text!.count > 0 || messageLabel.attributedText != nil {
                imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: messageLabel, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: -17))
            }  else if textFieldsArray.count > 0 {
                imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: textFieldView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: -17))
            } else {
                imageViewConstraints.append(NSLayoutConstraint.init(item: imageView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -bottomMargin))
            }
            NSLayoutConstraint.activate(imageViewConstraints)
            
        }
        
        // 对titleLabel和messageLabel布局
        var titleLabelConstraints = [NSLayoutConstraint]()
        var labels = [UILabel]()
        if titleLabel.text!.count > 0 || titleLabel.attributedText != nil {
            labels.insert(titleLabel, at: 0)
        }
        if messageLabel.text!.count > 0 || messageLabel.attributedText != nil {
            labels.append(messageLabel)
        }
        
        for (index, label) in labels.enumerated() {
            // 左右间距
            titleLabelConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==leftMargin)-[label]-(==rightMargin)-|", options: [], metrics: ["leftMargin": leftMargin, "rightMargin": rightMargin], views: ["label": label]))
            // 第一个子控件顶部间距
            if index == 0 {
                if nil == imageView.image {
                    titleLabelConstraints.append(NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1.0, constant: topMargin))
                }
            }
            
            // 最后一个子控件底部间距
            if index == labels.count - 1 {
                if textFieldsArray.count > 0 {
                    titleLabelConstraints.append(NSLayoutConstraint.init(item: label, attribute: .bottom, relatedBy: .equal, toItem: textFieldView, attribute: .top, multiplier: 1.0, constant: -bottomMargin))
                } else {
                    titleLabelConstraints.append(NSLayoutConstraint.init(item: label, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1.0, constant: -bottomMargin))
                }
            }
            // 子控件之间的垂直间距
            if index > 0 {
                titleLabelConstraints.append(NSLayoutConstraint.init(item: label, attribute: .top, relatedBy: .equal, toItem: labels[index-1], attribute: .bottom, multiplier: 1.0, constant: 7.5))
            }
        }
        NSLayoutConstraint.activate(titleLabelConstraints)
        
        if textFieldsArray.count > 0 {
            var textFieldViewConstraints = [NSLayoutConstraint]()
            // 没有titleLabel、messageLabel和iconView，
            // textFieldView的顶部相对contentView,否则不用写,因为前面写好了
            if labels.count == 0 && imageView.image == nil {
                textFieldViewConstraints.append(NSLayoutConstraint.init(item: textFieldView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: topMargin))
            }
            
            textFieldViewConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-(==leftMargin)-[textFieldView]-(==rightMargin)-|", options: [], metrics: ["leftMargin": leftMargin, "rightMargin": rightMargin], views: ["textFieldView": textFieldView]))
            textFieldViewConstraints.append(NSLayoutConstraint.init(item: textFieldView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: contentView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -bottomMargin))
            NSLayoutConstraint.activate(textFieldViewConstraints)
        }
        
        // systemLayoutSizeFittingSize:方法获取子控件撑起contentView后的高度，
        // 如果子控件是UILabel，那么子label必须设置preferredMaxLayoutWidth
        // 否则当label多行文本时计算不准确
        let constantH = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let contentViewHeightConstraint = NSLayoutConstraint.init(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constantH)
        contentViewHeightConstraint.isActive = true

    }
    
}
