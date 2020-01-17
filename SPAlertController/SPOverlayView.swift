//
//  SPOverlayView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/6.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

class SPOverlayView: UIView {
    
    private var presentedView: UIView?
    private var effectView: UIVisualEffectView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAppearanceStyle(appearanceStyle: SPBackgroundViewAppearanceStyle, alpha: CGFloat) {
        switch appearanceStyle {
        case .translucent:
            self.effectView?.removeFromSuperview()
            self.effectView = nil
            var tempAlpha: CGFloat = alpha
            if alpha < 0 {
                tempAlpha = 0.5
            }
            self.backgroundColor = .init(white: 0, alpha: tempAlpha)
            self.alpha = 0
        case .blurExtraLight:
            let blur = UIBlurEffect.init(style: .extraLight)
            self.creatVisualEffectView(withBlu: blur, alpha: alpha)
            
        case .blurLight:
            let blur = UIBlurEffect.init(style: .light)
            self.creatVisualEffectView(withBlu: blur, alpha: alpha)
        case .blurDark:
            let blur = UIBlurEffect.init(style: .dark)
            self.creatVisualEffectView(withBlu: blur, alpha: alpha)
        }
    }
    
    func creatVisualEffectView(withBlu blur: UIBlurEffect, alpha: CGFloat) {
        self.backgroundColor = .clear
        let effectV = UIVisualEffectView.init(frame: self.bounds)
        effectV.effect = blur
        effectV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectV.isUserInteractionEnabled = false
        effectV.alpha = alpha
        self.addSubview(effectV)
        effectView = effectV
    }
    
}
