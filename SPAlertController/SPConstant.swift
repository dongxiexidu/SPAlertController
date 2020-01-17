//
//  SPConstant.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/11/27.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

let SP_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.size.width
let SP_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.size.height
let SP_LINE_COLOR: UIColor = UIColor.gray.withAlphaComponent(0.3)
let SP_NORMAL_COLOR: UIColor = UIColor.white.withAlphaComponent(0.7)
let SP_SELECTED_COLOR: UIColor = UIColor.init(white: 1.0, alpha: 0.4)
let SP_LINE_WIDTH: CGFloat = 1.0/UIScreen.main.scale
let Is_iPhoneX: Bool = SP_SCREEN_HEIGHT >= 812.0
let SP_STATUS_BAR_HEIGHT: CGFloat = Is_iPhoneX ? 44.0 : 20.0
let SP_ACTION_TITLE_FONTSIZE: CGFloat = 18.0
let SP_ACTION_HEIGHT: CGFloat = 55.0

public enum SPAlertControllerStyle {
    case actionSheet
    case alert
}

public enum SPAlertAnimationType: Int {
    case `default`
    case fromBottom
    case fromTop
    case fromRight
    case fromLeft
    
    case shrink
    case expand
    case fade
    case none
}

public enum SPAlertActionStyle {
    case `default`
    case cancel
    case destructive
}

public enum SPBackgroundViewAppearanceStyle {
    case translucent
    case blurDark
    case blurExtraLight
    case blurLight
}

