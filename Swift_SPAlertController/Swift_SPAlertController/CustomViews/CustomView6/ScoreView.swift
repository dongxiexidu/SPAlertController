//
//  ScoreView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/13.
//  Copyright © 2020 HeFahu. All rights reserved.
//

import UIKit

class ScoreView: UIView {

    var finishClickedClosure: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(starRatingView)
        self.addSubview(lineView)
        self.addSubview(finishButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func finishButtonAction() {
        finishClickedClosure?()
    }
    
    override func updateConstraints() {
        super.updateConstraints()
         
        // 星星
        starRatingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        starRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        starRatingView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        starRatingView.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: 0).isActive = true
        starRatingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // 线
        let lineH: CGFloat = 1.0/UIScreen.main.scale
        lineView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        lineView.bottomAnchor.constraint(equalTo: finishButton.topAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: lineH).isActive = true
        
        // 完成
        finishButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        finishButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        finishButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        finishButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    lazy var starRatingView: HCSStarRatingView = {
        let starRatingV = HCSStarRatingView()
        starRatingV.translatesAutoresizingMaskIntoConstraints = false
        starRatingV.maximumValue = 5
        starRatingV.minimumValue = 0
        starRatingV.value = 2
        starRatingV.spacing = 20
        starRatingV.tintColor = UIColor.init(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        starRatingV.allowsHalfStars = true
        return starRatingV
    }()
    
    lazy var lineView: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.lightGray
        line.alpha = 0.3
        return line
    }()

    lazy var finishButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.white
        let titleColor = UIColor.init(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitle("完成", for: .normal)
        btn.addTarget(self, action: #selector(finishButtonAction), for: .touchUpInside)
        return btn
    }()
    
}
