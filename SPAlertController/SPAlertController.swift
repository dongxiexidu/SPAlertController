//
//  SPAlertController.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/12/6.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

public class SPAlertController: UIViewController {
    
    /// Interactor class for pan gesture dismissal
    lazy var interactor = SPInteractiveTransition()
    /// 拖拽退出view,暂时只支持向下拖拽退出,.fromTop向上拖拽退出
    private var panGestureDismissal: Bool = true
    private var _customAlertView: UIView?
    private var _customHeaderView: UIView?
    private var _customActionSequenceView: UIView?
    internal var _componentView: UIView?
    
    internal var customViewSize: CGSize = .zero
    private var headerActionLineConstraints: [NSLayoutConstraint]?
    private var componentViewConstraints: [NSLayoutConstraint]?
    private var componentActionLineConstraints: [NSLayoutConstraint]?
    private var dimmingKnockoutBackdropView: UIView?
    internal var alertControllerViewConstraints: [NSLayoutConstraint]?
    private var headerViewConstraints: [NSLayoutConstraint]?
    private var actionSequenceViewConstraints: [NSLayoutConstraint]?
    
    internal var preferredStyle: SPAlertControllerStyle = .alert
    internal var delegate: SPAlertControllerDelegate?
    internal var animationType: SPAlertAnimationType = .default
    
    // 对话框的偏移量，y值为正向下偏移，为负向上偏移；x值为正向右偏移，为负向左偏移，
    //该属性只对SPAlertControllerStyleAlert样式有效,键盘的frame改变会自动偏移，如果手动设置偏移只会取手动设置的
    public var offsetForAlert: CGPoint = .zero {
        didSet{
            isForceOffset = true
            makeViewOffsetWithAnimated(false)
        }
    }
    
    /// 是否单击背景退出对话框,默认为YES
    public var tapBackgroundViewDismiss: Bool = true
    /// 默认为 无毛玻璃效果,黑色透明(默认是0.5透明)
    internal var backgroundViewAppearanceStyle: SPBackgroundViewAppearanceStyle = .translucent
    public var backgroundViewAlpha: CGFloat = 0.5
    
    
    /// 主标题
    public var mainTitle: String? {
        didSet {
            
            if self.isViewLoaded == false {
                return
            }
            // 如果条件为真，说明外界在对title赋值之前就已经使用了self.view，
            // 先走了viewDidLoad方法，如果先走的viewDidLoad，
            // 需要在title的setter方法中重新设置数据,以下setter方法中的条件同理
            headerView?.titleLabel.text = mainTitle
            
            // 文字发生变化后再更新布局，这里更新布局也不是那么重要，
            // 因为headerView中的布局方法只有当SPAlertController被present后才会走一次，
            // 而那时候，一般title,titleFont、message、messageFont等都是最新值，
            // 这里防止的是：在SPAlertController被present后的某个时刻
            // 再去设置title,titleFont等，我们要更新布局
            if presentationController?.presentingViewController != nil {
                // 这个if条件的意思是当SPAlertController被present后的某个时刻设置了title，
                // 如果在present之前设置的就不用更新，系统会主动更新
                headerView?.setNeedsUpdateConstraints()
            }
            
        }
    }
    /// 副标题
    public var message: String? {
        didSet {
            if self.isViewLoaded == false {
                return
            }
            headerView?.messageLabel.text = message
            if presentationController?.presentingViewController != nil {
                headerView?.setNeedsUpdateConstraints()
            }
        }
    }
    
    
    /// 头部图标，位置处于title之上,大小取决于图片本身大小
    public var image: UIImage?
    /// 主标题颜色
    public var titleColor: UIColor = .black {
        willSet (newValue){
            if self.isViewLoaded == false {
                return
            }
            headerView?.titleLabel.textColor = newValue
        }
    }
    /// 主标题字体,默认18,加粗
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: SP_ACTION_TITLE_FONTSIZE) {
        willSet (newValue){
            if self.isViewLoaded == false {
                return
            }
            headerView?.titleLabel.font = newValue
            if presentationController?.presentingViewController != nil {
                headerView?.setNeedsUpdateConstraints()
            }
        }
    }
    /// 副标题颜色
    public var messageColor: UIColor = UIColor.gray {
        willSet (newValue){
            if self.isViewLoaded == false {
                return
            }
            headerView?.messageLabel.textColor = newValue
        }
    }
    ///  副标题字体,默认16,未加粗
    public var messageFont: UIFont = UIFont.systemFont(ofSize: 16)
    /// 对齐方式(包括主标题和副标题)
    public var textAlignment: NSTextAlignment? {
        didSet {
            if let alignment = textAlignment {
                headerView?.titleLabel.textAlignment = alignment
                headerView?.messageLabel.textAlignment = alignment
            }
        }
    }
    
    public var imageLimitSize: CGSize = CGSize.init(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)) {
        willSet (newValue){
        
            headerView?.imageLimitSize = newValue
            if presentationController?.presentingViewController != nil {
                headerView?.setNeedsUpdateConstraints()
            }
        }
    }
    
    /*
    * action水平排列还是垂直排列
    * actionSheet样式下:默认为UILayoutConstraintAxisVertical(垂直排列), 如果设置为UILayoutConstraintAxisHorizontal(水平排列)，则除去取消样式action之外的其余action将水平排列
    * alert样式下:当actions的个数大于2，或者某个action的title显示不全时为UILayoutConstraintAxisVertical(垂直排列)，否则默认为UILayoutConstraintAxisHorizontal(水平排列)，此样式下设置该属性可以修改所有action的排列方式
    * 不论哪种样式，只要外界设置了该属性，永远以外界设置的优先
    */
    public var _actionAxis: NSLayoutConstraint.Axis = .horizontal
    //本框架任何一处都不允许调用actionAxis的setter方法，如果调用了则无法判断是外界调用还是内部调用
    public var actionAxis: NSLayoutConstraint.Axis? {
        didSet {
            guard let actonA = actionAxis else { return }
            // 调用该setter方法则认为是强制布局，该setter方法只有外界能调，
            // 这样才能判断外界有没有调用actionAxis的setter方法，从而是否按照外界的指定布局方式进行布局
            _actionAxis = actonA
            isForceLayout = true
            updateActionAxis()
        }
    }
    /* 距离屏幕边缘的最小间距
    * alert样式下该属性是指对话框四边与屏幕边缘之间的距离，此样式下默认值随设备变化，actionSheet样式下是指弹出边的对立边与屏幕之间的距离，比如如果从右边弹出，那么该属性指的就是对话框左边与屏幕之间的距离，此样式下默认值为70
    */
    public var minDistanceToEdges: CGFloat = 70 {
        didSet {
            if self.isViewLoaded == false {
                return
            }
            if let headerV = headerView {
                setupPreferredMaxLayoutWidthForLabel(headerV.titleLabel)
                setupPreferredMaxLayoutWidthForLabel(headerV.messageLabel)
            }
            
            if presentationController?.presentingViewController != nil {
                layoutAlertControllerView()
                headerView?.setNeedsUpdateConstraints()
                actionSequenceView?.setNeedsUpdateConstraints()
            }
        }
    }
    /// SPAlertControllerStyleAlert样式下默认6.0f，
    /// SPAlertControllerStyleActionSheet样式下默认13.0f，去除半径设置为0即可
    public var cornerRadius: CGFloat = 6.0 {
        didSet {
            _updateCornerRadius(cornerRadius: cornerRadius)
        }
    }
    
    func _updateCornerRadius(cornerRadius: CGFloat) {
        if preferredStyle == .alert {
            containerView.layer.cornerRadius = cornerRadius
            containerView.layer.masksToBounds = true
        } else {
            if cornerRadius > 0.0 {
                var corner = [UIRectCorner.topLeft, UIRectCorner.topRight]
                switch animationType {
                case .fromBottom:
                    corner = [.topLeft, .topRight]
                case .fromTop:
                    corner = [.bottomLeft, .bottomRight]
                case .fromLeft:
                    corner = [.topRight, .bottomRight]
                case .fromRight:
                    corner = [.topLeft, .bottomLeft]
                default:
                    break
                }
                
                if let maskLayer = containerView.layer.mask as? CAShapeLayer {
                    maskLayer.path = UIBezierPath.init(roundedRect: containerView.bounds, byRoundingCorners: UIRectCorner.init(corner), cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius)).cgPath
                    maskLayer.frame = containerView.bounds
                }
            } else {
                containerView.layer.mask = nil
            }
        }
    }
    
    public var attributedTitle: NSAttributedString? {
        didSet {
            if self.isViewLoaded == false {
                return
            }
            headerView?.titleLabel.attributedText = attributedTitle
            if presentationController?.presentingViewController != nil {
                headerView?.setNeedsUpdateConstraints()
            }
        }
    }
    public var attributedMessage: NSAttributedString? {
        didSet {
            if self.isViewLoaded == false {
                return
            }
            headerView?.messageLabel.attributedText = attributedMessage
            if presentationController?.presentingViewController != nil {
                headerView?.setNeedsUpdateConstraints()
            }
        }
    }
    
    /// 是否需要对话框拥有毛玻璃,默认为false
    public var needDialogBlur: Bool = false {
        
        didSet {
            updateDialogBlur(needDialogBlur: needDialogBlur)
        }
    }
    
    private func updateDialogBlur(needDialogBlur: Bool) {
        if needDialogBlur == true {
            containerView.backgroundColor = .clear
            if let dimmingdropView = NSClassFromString("_UIDimmingKnockoutBackdropView")?.alloc() as? UIView {
//                DLog("_UIDimmingKnockoutBackdropView 有值")
                // 下面4行相当于self.dimmingKnockoutBackdropView = [self.dimmingKnockoutBackdropView performSelector:NSSelectorFromString(@"initWithStyle:") withObject:@(UIBlurEffectStyleLight)];
                let selector = NSSelectorFromString("initWithStyle:")
                dimmingdropView.perform(selector, with: UIBlurEffect.Style.light)
                dimmingdropView.frame = containerView.bounds
                dimmingdropView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                dimmingKnockoutBackdropView = dimmingdropView
                dimmingKnockoutBackdropView?.backgroundColor = .white
                self.containerView.insertSubview(dimmingKnockoutBackdropView!, at: 0)
            } else {
                // 这个else是防止假如_UIDimmingKnockoutBackdropView这个类不存在了的时候，做一个备案
                let blur = UIBlurEffect.init(style: UIBlurEffect.Style.extraLight)
                dimmingKnockoutBackdropView = UIVisualEffectView.init(effect: blur)
                dimmingKnockoutBackdropView!.frame = containerView.bounds
                dimmingKnockoutBackdropView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.containerView.insertSubview(dimmingKnockoutBackdropView!, at: 0)
            }
            
        } else {
            dimmingKnockoutBackdropView?.removeFromSuperview()
            dimmingKnockoutBackdropView = nil
            if _customAlertView != nil {
                containerView.backgroundColor = .clear
            } else {
                containerView.backgroundColor = .white
            }
        }
    }
    
    // readonly
    public var actions: [SPAlertAction] = [SPAlertAction]()
    // 除去取消样式action的其余action数组
    internal var otherActions = [SPAlertAction]()
    internal var textFields = [UITextField]()
    /// 是否强制排列，外界设置了actionAxis属性认为是强制
    var isForceLayout: Bool = false
    /// 是否强制偏移，外界设置了offsetForAlert属性认为是强制
    var isForceOffset: Bool = true
    
    //MARK: - lazy var

    // 注意:Obj-C中`@property (nonatomic, weak)`中通常用strong强引用,
    // 弱引用的view必须要添加到父view中才有值
    var _actionSequenceView: SPInterfaceActionSequenceView?
    var actionSequenceView: SPInterfaceActionSequenceView?{
        if _actionSequenceView == nil {
            let actionV = SPInterfaceActionSequenceView.init()
            actionV.translatesAutoresizingMaskIntoConstraints = false
            actionV.buttonClickedInActionViewClosure = { [weak self] index in
                if let action = self?.actions[index] {
                    if action.dismissOnTap == true {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    action.handler?(action)
                }
            }
            if self.actions.count > 0 && self.customActionSequenceView == nil && self.alertView != nil{
                self.alertView!.addSubview(actionV)
                _actionSequenceView = actionV
            }
        }
        return _actionSequenceView
    }
    
    
    //
    var _componentActionLine: SPInterfaceActionItemSeparatorView?
    var componentActionLine: SPInterfaceActionItemSeparatorView? {
        if _componentActionLine == nil {
            let componentL = SPInterfaceActionItemSeparatorView()
            componentL.translatesAutoresizingMaskIntoConstraints = false
            let flag = (actionSequenceView?.superview != nil || customActionSequenceView?.superview != nil)
            // 必须组件view和action部分同时存在
            if _componentView?.superview != nil && flag {
                self.alertView!.addSubview(componentL)
                _componentActionLine = componentL
            }
        }
        return _componentActionLine
    }
    var _alertView: UIView?
    var alertView: UIView? {
        if _alertView == nil {
            let alert = UIView()
            //alert.backgroundColor = .lightGray
            alert.frame = self.alertControllerView.bounds
            alert.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if self.customAlertView == nil {
                _alertView = alert
                self.containerView.addSubview(alert)
            }
        }
        return _alertView
    }
    
    lazy var alertControllerView: UIView = {
        let alertC = UIView()
       // alertC.backgroundColor = .blue
        alertC.translatesAutoresizingMaskIntoConstraints = false
        return alertC
    }()
    
    var customAlertView: UIView? {
        // customAlertView有值但是没有父view
        if _customAlertView != nil && _customAlertView?.superview == nil {
            if customViewSize.equalTo(.zero) {
                // 获取_customAlertView的大小
                customViewSize = sizeForCustomView(_customAlertView!)
            }
            // 必须在在下面2行代码之前获取_customViewSize
            _customAlertView?.frame = alertControllerView.bounds
            _customAlertView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.containerView.addSubview(_customAlertView!)
        }
        return _customAlertView
    }
    var customHeaderView: UIView? {
        // _customHeaderView有值但是没有父view
        if _customHeaderView != nil && _customHeaderView?.superview == nil {
            if customViewSize.equalTo(.zero) {
                // 获取_customHeaderView的大小
                customViewSize = sizeForCustomView(_customHeaderView!)
            }
            _customHeaderView?.translatesAutoresizingMaskIntoConstraints = false
            self.alertView?.addSubview(_customHeaderView!)
        }
        return _customHeaderView
    }
    var customActionSequenceView: UIView? {
        // _customActionSequenceView有值但是没有父view
        if _customActionSequenceView != nil && _customActionSequenceView?.superview == nil {
            if customViewSize.equalTo(.zero) {
                // 获取_customHeaderView的大小
                customViewSize = sizeForCustomView(_customActionSequenceView!)
            }
            _customActionSequenceView?.translatesAutoresizingMaskIntoConstraints = false
            self.alertView?.addSubview(_customActionSequenceView!)
        }
        return _customActionSequenceView
    }
    
    //
    var componentView: UIView? {
        // _componentView有值但是没有父view
        if _componentView != nil && _componentView?.superview == nil {
            assert(self.headerActionLine!.superview != nil, "Due to the -componentView is added between the -head and the -action section, the -head and -action must exist together")
            // 获取_componentView的大小
            if customViewSize.equalTo(.zero) {
                customViewSize = sizeForCustomView(_componentView!)
            }
            
            _componentView?.translatesAutoresizingMaskIntoConstraints = false
            self.alertView!.addSubview(_componentView!)
        }
        return _componentView
    }
    
    lazy var containerView: UIView = {
        let containerV = UIView()
        containerV.backgroundColor = .white
        containerV.frame = self.alertControllerView.bounds
        containerV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if preferredStyle == .alert {
            containerV.layer.cornerRadius = cornerRadius
            containerV.layer.masksToBounds = true
        } else {
            if cornerRadius > 0.0 {
                let maskLayer = CAShapeLayer.init()
                containerV.layer.mask = maskLayer
            }
        }
        alertControllerView.addSubview(containerV)
        return containerV
    }()
    
    
    var _headerView: SPInterfaceHeaderScrollView?
    var headerView: SPInterfaceHeaderScrollView? {
        if _headerView == nil {
            let header = SPInterfaceHeaderScrollView()
            header.backgroundColor = SP_NORMAL_COLOR
            // header.backgroundColor = .red
            header.translatesAutoresizingMaskIntoConstraints = false
            header.headerViewSafeAreaDidChangeClosure = { [weak self] in
                self?.setupPreferredMaxLayoutWidthForLabel(header.titleLabel)
                self?.setupPreferredMaxLayoutWidthForLabel(header.messageLabel)
            }
            if self.customHeaderView == nil {
                if (mainTitle != nil && mainTitle!.count > 0) || attributedTitle != nil || (message != nil && message!.count > 0) || attributedMessage != nil || textFields.count > 0 || image != nil{
                    _headerView = header
                    self.alertView?.addSubview(header)
                }
            }
        }
        return _headerView
        
    }

    var _headerActionLine: SPInterfaceActionItemSeparatorView?
    var headerActionLine: SPInterfaceActionItemSeparatorView? {
        if _headerActionLine == nil {
            let headerLine = SPInterfaceActionItemSeparatorView()
            headerLine.translatesAutoresizingMaskIntoConstraints = false
            let flag1 = (headerView?.superview != nil || customHeaderView?.superview != nil)
            let flag2 = (actionSequenceView?.superview != nil || customActionSequenceView?.superview != nil)
//            DLog("flag1=\(flag1) flag2=\(flag2) ")
            if flag1 && flag2 {
                _headerActionLine = headerLine
                self.alertView?.addSubview(headerLine)
            }
        }
        return _headerActionLine
    }
    
    //MARK: - system methods
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // 先loadView(),后viewDidLoad()
    override public func loadView() {
         super.loadView()
        // 重新创建self.view，这样可以采用自己的一套布局，轻松改变控制器view的大小
        self.view = self.alertControllerView
       // self.view.backgroundColor = .blue
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        configureHeaderView()
        updateDialogBlur(needDialogBlur: self.needDialogBlur)
        if #available(iOS 11.0, *) {
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
       // self.view.backgroundColor = .blue
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handleIQKeyboardManager()
        if !isForceOffset && customAlertView == nil && customHeaderView == nil && customActionSequenceView == nil && componentView == nil{
            // 监听键盘改变frame，键盘frame改变需要移动对话框
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }
        if textFields.count > 0 {
            let firstTextfield = textFields[0]
            if !firstTextfield.isFirstResponder {
                firstTextfield.becomeFirstResponder()
            }
        }
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
       // DLog("viewWillLayoutSubviews ++++++++++++")
        // 屏幕旋转后宽高发生了交换，头部的label最大宽度需要重新计算
        if let headerV = headerView {
            setupPreferredMaxLayoutWidthForLabel(headerV.titleLabel)
            setupPreferredMaxLayoutWidthForLabel(headerV.messageLabel)
        }
        
        // 对自己创建的alertControllerView布局，在这个方法里，self.view才有父视图，有父视图才能改变其约束
        layoutAlertControllerView()
        layoutChildViews()
        if preferredStyle == .actionSheet {
            _updateCornerRadius(cornerRadius: cornerRadius)
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 文字显示不全处理
        handleIncompleteTextDisplay()
    }
    
    
    
    // 这个方法是实现点击回车切换到下一个textField，
    // 如果没有下一个，会自动退出键盘
    // 不能在代理方法里实现，因为如果设置了代理，
    // 外界就不能成为textFiled的代理了，通知也监听不到回车
    @objc func textFieldDidEndOnExit(textField: UITextField){
        var index: Int = 0
        for (i, item) in self.textFields.enumerated() {
            if item == textField {
                index = i
                break
            }
        }
        if textFields.count > index+1 {
            let nextTextField = textFields[index+1]
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
    }
    
    
    func layoutAlertControllerViewForAlertStyle() {
        var alertControllerViewConstraints = [NSLayoutConstraint]()
        let topValue = minDistanceToEdges
        let bottomValue = minDistanceToEdges
        let maxWidth = min(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)-minDistanceToEdges*2
        let maxHeight = SP_SCREEN_HEIGHT-topValue-bottomValue
        if self.customAlertView == nil {
            // 当屏幕旋转的时候，为了保持alert样式下的宽高不变，因此取MIN(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)
            alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: maxWidth))
            
        } else {
            alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: maxWidth))
            // 如果宽度没有值，则会假定customAlertView水平方向能由子控件撑起
            if customViewSize.width > 0 {
                // 限制最大宽度，且能保证内部约束不报警告
                let customWidth = min(customViewSize.width, maxWidth)
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customWidth))
            }
             // 如果高度没有值，则会假定customAlertView垂直方向能由子控件撑起
            if customViewSize.height > 0 {
                let customHeight = min(customViewSize.height, maxHeight)
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customHeight))
            }
        }
        let topConstraint = NSLayoutConstraint.init(item: alertControllerView, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: alertControllerView.superview, attribute: .top, multiplier: 1.0, constant: topValue)
        topConstraint.priority = UILayoutPriority.init(999.0)
        alertControllerViewConstraints.append(topConstraint)
        //这里优先级为999.0是为了小于垂直中心的优先级，如果含有文本输入框，键盘弹出后，特别是旋转到横屏后，对话框的空间比较小，这个时候优先偏移垂直中心，顶部优先级按理说应该会被忽略，但是由于子控件含有scrollView，所以该优先级仍然会被激活，子控件显示不全scrollView可以滑动。如果外界自定义了整个对话框，且自定义的view上含有文本输入框，子控件不含有scrollView，顶部间距会被忽略
        let bottomConstraint = NSLayoutConstraint.init(item: alertControllerView, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: alertControllerView.superview, attribute: .bottom, multiplier: 1.0, constant: -bottomValue)
        bottomConstraint.priority = UILayoutPriority.init(999.0)// 优先级跟顶部同理
        alertControllerViewConstraints.append(bottomConstraint)
        
        let centerXConstraints = NSLayoutConstraint.init(item: alertControllerView, attribute: .centerX, relatedBy: .equal, toItem: alertControllerView.superview, attribute: .centerX, multiplier: 1.0, constant: offsetForAlert.x)
        alertControllerViewConstraints.append(centerXConstraints)
        
        let constantY = (self.isBeingPresented && !self.isBeingDismissed)  ? 0 : offsetForAlert.y
        let centerYConstraints = NSLayoutConstraint.init(item: alertControllerView, attribute: .centerY, relatedBy: .equal, toItem: alertControllerView.superview, attribute: .centerY, multiplier: 1.0, constant: constantY)
        alertControllerViewConstraints.append(centerYConstraints)
        
        NSLayoutConstraint.activate(alertControllerViewConstraints)
        self.alertControllerViewConstraints = alertControllerViewConstraints
        
//        DLog("alertControllerView=\(alertControllerView)")
    }
    
    func layoutAlertControllerViewForActionSheetStyle() {
        switch animationType {
        case .fromTop:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "H",
                                                            equalAttribute: .top,
                                                            notEqualAttribute: .bottom,
                                                            lessOrGreaterRelation: .lessThanOrEqual)
        case .fromBottom:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "H",
                                                            equalAttribute: .bottom,
                                                            notEqualAttribute: .top,
                                                            lessOrGreaterRelation: .greaterThanOrEqual)
        case .fromLeft, .fromRight:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "V",
                                                            equalAttribute: .left,
                                                            notEqualAttribute: .right,
                                                            lessOrGreaterRelation: .lessThanOrEqual)
        default:
            layoutAlertControllerViewForAnimationTypeWithHV(hv: "H",
                                                            equalAttribute: .bottom,
                                                            notEqualAttribute: .top,
                                                            lessOrGreaterRelation: .greaterThanOrEqual)
        }
    }
}

//MARK: - private method
extension SPAlertController {
    // 专门处理第三方IQKeyboardManager,非自定义view时禁用IQKeyboardManager移动textView/textField效果，自定义view时取消禁用
    // TODO: IQKeyboardManager
    private func handleIQKeyboardManager() {
        let selector = NSSelectorFromString("sharedManager")
        let imp = NSClassFromString("IQKeyboardManager")?.method(for: selector)
        
        if imp != nil {
            
        }
    }
    // private
    internal convenience init(title: String?,
                     message: String?,
                     customAlertView: UIView?,
                     customHeaderView: UIView?,
                     customActionSequenceView: UIView?,
                     componentView: UIView?,
                     preferredStyle: SPAlertControllerStyle,
                     animationType: SPAlertAnimationType,
                     panGestureDismissal: Bool) {
        
        self.init()
        self.mainTitle = title
        self.message = message
        self.preferredStyle = preferredStyle
        
        self.animationType = animationType
        // 如果是默认动画，preferredStyle为alert时动画默认为alpha，
        // preferredStyle为actionShee时动画默认为fromBottom
        if animationType == .default {
            if preferredStyle == .alert {
                self.animationType = .shrink
            } else {
                self.animationType = .fromBottom
            }
        }
       
        if preferredStyle == .alert {
            self.minDistanceToEdges = (min(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)-275)/2
            _actionAxis = .horizontal
        } else {
            self.minDistanceToEdges = 70
            _actionAxis = .vertical
            self.cornerRadius = 13
        }
        self._customAlertView = customAlertView
        self._customHeaderView = customHeaderView
        self._customActionSequenceView = customActionSequenceView
        // componentView参数是为了支持老版本的自定义footerView
        self._componentView = componentView
        self.panGestureDismissal = panGestureDismissal
        
        let flag1 = (preferredStyle == .actionSheet && animationType == .fromRight)
        let flag2 = (preferredStyle == .actionSheet && animationType == .fromLeft)
        // Allow for dialog dismissal on dialog pan gesture
        if self.panGestureDismissal && flag1 && flag2{
            let panRecognizer = UIPanGestureRecognizer(target: interactor, action: #selector(SPInteractiveTransition.handlePan))
            panRecognizer.cancelsTouchesInView = false
            interactor.viewController = self
            alertControllerView.addGestureRecognizer(panRecognizer)
        }
        
        // 视图控制器定义它呈现视图控制器的过渡风格（默认为NO）
        self.providesPresentationContextTransitionStyle = true
        self.definesPresentationContext = true
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self
    }
    
    func layoutAlertControllerViewForAnimationTypeWithHV(hv: String,
                                                         equalAttribute: NSLayoutConstraint.Attribute,
                                                         notEqualAttribute: NSLayoutConstraint.Attribute,
                                                         lessOrGreaterRelation relation: NSLayoutConstraint.Relation){
        
        var alertControllerViewConstraints = [NSLayoutConstraint]()
        if self.customAlertView == nil {
            let visualFormat = "\(hv):|-0-[alertControllerView]-0-|"
            //DLog(visualFormat)
            alertControllerViewConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: ["alertControllerView": alertControllerView]))
        } else {
            let centerXorY = (hv == "H") ? NSLayoutConstraint.Attribute.centerX : NSLayoutConstraint.Attribute.centerY
            alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: centerXorY, relatedBy: .equal, toItem: alertControllerView.superview, attribute: centerXorY, multiplier: 1.0, constant: 0))
            if customViewSize.width > 0 {
                // 如果宽度没有值，则会假定customAlertViewh水平方向能由子控件撑起
                var alertControllerViewWidth: CGFloat = 0
                if hv == "H" {
                    alertControllerViewWidth = min(customViewSize.width, SP_SCREEN_WIDTH)
                } else {
                    alertControllerViewWidth = min(customViewSize.width, SP_SCREEN_WIDTH-minDistanceToEdges)
                }
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: alertControllerViewWidth))
            }
            if (customViewSize.height > 0) {
                // 如果高度没有值，则会假定customAlertViewh垂直方向能由子控件撑起
                var alertControllerViewHeight: CGFloat = 0
                if hv == "H" {
                    alertControllerViewHeight = min(customViewSize.height, SP_SCREEN_HEIGHT-minDistanceToEdges)
                } else {
                    alertControllerViewHeight = min(customViewSize.height, SP_SCREEN_HEIGHT)
                }
                alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: alertControllerViewHeight))
            }
        }
        
        alertControllerViewConstraints.append(NSLayoutConstraint.init(item: alertControllerView, attribute: equalAttribute, relatedBy: .equal, toItem: alertControllerView.superview, attribute: equalAttribute, multiplier: 1.0, constant: 0))
        let someSideConstraint = NSLayoutConstraint.init(item: alertControllerView, attribute: notEqualAttribute, relatedBy: relation, toItem: alertControllerView.superview, attribute: notEqualAttribute, multiplier: 1.0, constant: minDistanceToEdges)
        someSideConstraint.priority = UILayoutPriority.init(999.0)
        alertControllerViewConstraints.append(someSideConstraint)
        NSLayoutConstraint.activate(alertControllerViewConstraints)
        // 第二次和第三次 alertControllerView:frame = (0 667; 375 0)  UITransitionView: 0x7f8c4bf15620; frame = (0 0; 375 667);
//        DLog(alertControllerView)
        self.alertControllerViewConstraints = alertControllerViewConstraints
    }
    
    internal func layoutChildViews() {
        // 对头部布局
        layoutHeaderView()
        // 对头部和action部分之间的分割线布局
        layoutHeaderActionLine()
        // 对组件view布局
        layoutComponentView()
        // 对组件view与action部分之间的分割线布局
        layoutComponentActionLine()
        // 对action部分布局
        layoutActionSequenceView()
    }
    
    // 对头部布局
    private func layoutHeaderView() {
        let headerVTemp = customHeaderView != nil ? customHeaderView! : self.headerView
        guard let headerV = headerVTemp else { return }
        if headerV.superview == nil {
            return
        }
        if let constraints = self.headerViewConstraints {
            NSLayoutConstraint.deactivate(constraints)
            self.headerViewConstraints = nil
        }
        var headerViewConstraints = [NSLayoutConstraint]()
        if customHeaderView == nil {
            headerViewConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headerV]-0-|", options: [], metrics: nil, views: ["headerV": headerV]))
        } else {
            if customViewSize.width > 0 {
                let maxWidth = getMaxWidth()
                let headerViewWidth = min(maxWidth, customViewSize.width)
                headerViewConstraints.append(NSLayoutConstraint.init(item: headerV, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: headerViewWidth))
            }
            if customViewSize.height > 0 {
                let customHeightConstraint = NSLayoutConstraint.init(item: headerV, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customViewSize.height)
                customHeightConstraint.priority = .defaultHigh
                headerViewConstraints.append(customHeightConstraint)
            }
            headerViewConstraints.append(NSLayoutConstraint.init(item: headerV, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1.0, constant: 0))
        }
        headerViewConstraints.append(NSLayoutConstraint.init(item: headerV, attribute: .top, relatedBy: .equal, toItem: alertView, attribute: .top, multiplier: 1.0, constant: 0))
        
        if headerActionLine?.superview == nil {
            headerViewConstraints.append(NSLayoutConstraint.init(item: headerV, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1.0, constant: 0))
        }
        NSLayoutConstraint.activate(headerViewConstraints)
        self.headerViewConstraints = headerViewConstraints
        
       // DLog("alertView = \(alertView)")
    }
    
    // 对头部和action部分之间的分割线布局
    private func layoutHeaderActionLine() {
        guard let headerActionLine = headerActionLine else { return }
        if headerActionLine.superview == nil {
            return
        }

        let headerVTemp = customHeaderView != nil ? customHeaderView! : headerView
        guard let headerV = headerVTemp else { return }
        
        let actionSequenceV: UIView = customActionSequenceView != nil ? customActionSequenceView! : self.actionSequenceView!
        if let constraints = self.headerActionLineConstraints {
            NSLayoutConstraint.deactivate(constraints)
            self.headerActionLineConstraints = nil
        }
        
        var headerActionLineConstraints = [NSLayoutConstraint]()
        headerActionLineConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[headerActionLine]-0-|", options: [], metrics: nil, views: ["headerActionLine": headerActionLine]))
        headerActionLineConstraints.append(NSLayoutConstraint.init(item: headerActionLine, attribute: .top, relatedBy: .equal, toItem: headerV, attribute: .bottom, multiplier: 1.0, constant: 0))
        if self.componentView?.superview == nil {
            headerActionLineConstraints.append(NSLayoutConstraint.init(item: headerActionLine, attribute: .bottom, relatedBy: .equal, toItem: actionSequenceV, attribute: .top, multiplier: 1.0, constant: 0))
        }
        headerActionLineConstraints.append(NSLayoutConstraint.init(item: headerActionLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: SP_LINE_WIDTH))
        NSLayoutConstraint.activate(headerActionLineConstraints)
        self.headerActionLineConstraints = headerActionLineConstraints
    }
    
    // 对组件view布局
    private func layoutComponentView() {
        guard let componentView = componentView else { return }
        if componentView.superview == nil {
            return
        }
        if let constraints = self.componentViewConstraints {
            NSLayoutConstraint.deactivate(constraints)
            self.componentViewConstraints = nil
        }
        var componentViewConstraints = [NSLayoutConstraint]()
        componentViewConstraints.append(NSLayoutConstraint.init(item: componentView, attribute: .top, relatedBy: .equal, toItem: headerActionLine, attribute: .bottom, multiplier: 1.0, constant: 0))
        componentViewConstraints.append(NSLayoutConstraint.init(item: componentView, attribute: .bottom, relatedBy: .equal, toItem: componentActionLine, attribute: .top, multiplier: 1.0, constant: 0))
        componentViewConstraints.append(NSLayoutConstraint.init(item: componentView, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        if customViewSize.height > 0 {
            let heightConstraint = NSLayoutConstraint.init(item: componentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customViewSize.height)
            heightConstraint.priority = .defaultHigh
            componentViewConstraints.append(heightConstraint)
        }
        if customViewSize.width > 0 {
            let maxWidth = getMaxWidth()
            let componentViewWidth = min(maxWidth, customViewSize.width)
            componentViewConstraints.append(NSLayoutConstraint.init(item: componentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: componentViewWidth))
        }
        NSLayoutConstraint.activate(componentViewConstraints)
        self.componentViewConstraints = componentViewConstraints
    }
    
    // 对组件view与action部分之间的分割线布局
    private func layoutComponentActionLine() {
        guard let componentActionLine = componentActionLine else { return }
        if componentActionLine.superview == nil {
            return
        }
        if let constraints = self.componentActionLineConstraints {
            NSLayoutConstraint.deactivate(constraints)
            self.componentActionLineConstraints = nil
        }
        var componentActionLineConstraints = [NSLayoutConstraint]()
        componentActionLineConstraints.append(NSLayoutConstraint.init(item: componentActionLine, attribute: .bottom, relatedBy: .equal, toItem: actionSequenceView, attribute: .top, multiplier: 1.0, constant: 0))
        
        componentActionLineConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[componentActionLine]-0-|", options: [], metrics: nil, views: ["componentActionLine": componentActionLine]))
        componentActionLineConstraints.append(NSLayoutConstraint.init(item: componentActionLine, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: SP_LINE_WIDTH))
        NSLayoutConstraint.activate(componentActionLineConstraints)
        self.componentActionLineConstraints = componentActionLineConstraints
    }
    // 对action部分布局,高度由子控件撑起
    private func layoutActionSequenceView() {
        let actionSequenceViewTemp = customActionSequenceView != nil ? customActionSequenceView! : self.actionSequenceView
        guard let actionSequenceView = actionSequenceViewTemp else { return }
        if actionSequenceView.superview == nil {
            return
        }
        
        if let constraints = self.actionSequenceViewConstraints {
            NSLayoutConstraint.deactivate(constraints)
            self.actionSequenceViewConstraints = nil
        }
        var actionSequenceViewConstraints = [NSLayoutConstraint]()
        if customActionSequenceView == nil {
            actionSequenceViewConstraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[actionSequenceView]-0-|", options: [], metrics: nil, views: ["actionSequenceView": actionSequenceView]))
        } else {
            if customViewSize.width > 0 {
                let maxWidth = getMaxWidth()
                if customViewSize.width > maxWidth {
                    customViewSize.width = maxWidth
                }
                actionSequenceViewConstraints.append(NSLayoutConstraint.init(item: actionSequenceView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customViewSize.width))
            }
            
            if customViewSize.height > 0 {
                let customHeightConstraint = NSLayoutConstraint.init(item: actionSequenceView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: customViewSize.height)
                customHeightConstraint.priority = .defaultHigh
                actionSequenceViewConstraints.append(customHeightConstraint)
            }
            actionSequenceViewConstraints.append(NSLayoutConstraint.init(item: actionSequenceView, attribute: .centerX, relatedBy: .equal, toItem: alertView, attribute: .centerX, multiplier: 1.0, constant: 0))
        }
       
        if headerActionLine == nil {
            actionSequenceViewConstraints.append(NSLayoutConstraint.init(item: actionSequenceView, attribute: .top, relatedBy: .equal, toItem: alertView, attribute: .top, multiplier: 1.0, constant: 0))
        }
        actionSequenceViewConstraints.append(NSLayoutConstraint.init(item: actionSequenceView, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate(actionSequenceViewConstraints)
        self.actionSequenceViewConstraints = actionSequenceViewConstraints
    }
    
    internal func updateActionAxis() {
        actionSequenceView?.axis = _actionAxis
        if _actionAxis == .vertical {// 布局方式为子控件自适应内容高度
            actionSequenceView?.stackViewDistribution = .fillProportionally
        } else {// 布局方式为子控件等宽
            actionSequenceView?.stackViewDistribution = .fillEqually
        }
    }
    
    private func getMaxWidth() -> CGFloat {
        if preferredStyle == .alert {
            return min(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)-minDistanceToEdges*2
        } else {
            return SP_SCREEN_WIDTH
        }
    }
    
    // 文字显示不全处理
    internal func handleIncompleteTextDisplay() {
        // alert样式下水平排列时如果文字显示不全则垂直排列
        if self.isForceLayout {
            return
        }
        if preferredStyle != .alert {
            return
        }
        // 外界没有设置排列方式
        for action in self.actions {
            let minus: CGFloat = minDistanceToEdges*2+SP_LINE_WIDTH*CGFloat((actions.count - 1)/actions.count)+action.titleEdgeInsets.left+action.titleEdgeInsets.right
            // 预估按钮宽度
            let preButtonWidth = min(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)-minus
            // 如果action的标题文字总宽度，大于按钮的contentRect的宽度，
            // 则说明水平排列会导致文字显示不全，此时垂直排列
            if let attrs = action.attributedTitle {
                let width = attrs.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: SP_ACTION_HEIGHT), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.width
                
                if ceilf(Float(width)) > Float(preButtonWidth) {

                    _actionAxis = .vertical
                    updateActionAxis()
                    actionSequenceView?.setNeedsUpdateConstraints()
                    break// 一定要break，只要有一个按钮文字过长就垂直排列
                }
                
            } else {
                guard let title = action.title else { return }
                let width = title.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: SP_ACTION_HEIGHT), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: action.titleFont], context: nil).size.width
                if ceilf(Float(width)) > Float(preButtonWidth){
                    _actionAxis = .vertical
                    updateActionAxis()
                    actionSequenceView?.setNeedsUpdateConstraints()
                    break
                }
            }
            
        }
    }
    
    //MARK: 键盘通知
    @objc func keyboardFrameWillChange(noti: Notification) {
        if !isForceOffset {
            //键盘高度
            guard let keyRect = (noti.userInfo!["UIKeyboardFrameEndUserInfoKey"] as AnyObject).cgRectValue else {
                return
            }
            let keyboardEndY = keyRect.origin.y
            let diff = abs((SP_SCREEN_HEIGHT-keyboardEndY)*0.5)
            offsetForAlert.y = -diff
            self.makeViewOffsetWithAnimated(true)
        }
    }
    
    internal func makeViewOffsetWithAnimated(_ animated: Bool) {
        if !self.isBeingPresented && !self.isBeingDismissed {
            layoutAlertControllerView()
            if animated {
                UIView.animate(withDuration: 0.25) {
                    self.view.superview?.layoutIfNeeded()
                }
            }
        }
    }
    
    private func sizeForCustomView(_ customView: UIView) -> CGSize{
        
        customView.layoutIfNeeded()
        let settingSize = customView.frame.size
        let fittingSize = customView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
        let width = max(settingSize.width, fittingSize.width)
        let height = max(settingSize.height, fittingSize.height)
        return CGSize.init(width:width , height: height)
    }
    
    private func setupPreferredMaxLayoutWidthForLabel(_ textLabel: UILabel) {
        if preferredStyle == .alert {
            let minus = minDistanceToEdges*2+headerView!.contentEdgeInsets.left+headerView!.contentEdgeInsets.right
            textLabel.preferredMaxLayoutWidth = min(SP_SCREEN_WIDTH, SP_SCREEN_HEIGHT)-minus
        } else {
            let minus = headerView!.contentEdgeInsets.left+headerView!.contentEdgeInsets.right
//            DLog(minus)
            textLabel.preferredMaxLayoutWidth = SP_SCREEN_WIDTH-minus
//            DLog(textLabel.preferredMaxLayoutWidth)
        }
    }
    
    func configureHeaderView() {
        if let img = image {
            headerView?.imageLimitSize = imageLimitSize
            headerView?.imageView.image = img
            headerView?.setNeedsUpdateConstraints()
        }
        
        if let attrTitle = attributedTitle, attrTitle.length > 0 {
            headerView?.titleLabel.attributedText = attrTitle
            setupPreferredMaxLayoutWidthForLabel(headerView!.titleLabel)
        } else if mainTitle != nil && mainTitle!.count > 0 {
            headerView?.titleLabel.text = mainTitle
            headerView?.titleLabel.font = titleFont
            headerView?.titleLabel.textColor = titleColor
            if let alignment = textAlignment {
                headerView?.titleLabel.textAlignment = alignment
            }
            setupPreferredMaxLayoutWidthForLabel(headerView!.titleLabel)
        }
        
        if let attrTitle = attributedMessage, attrTitle.length > 0  {
            headerView?.messageLabel.attributedText = attrTitle
            setupPreferredMaxLayoutWidthForLabel(headerView!.messageLabel)
        } else if (message != nil && message!.count > 0) {
            headerView!.messageLabel.text = message
            headerView!.messageLabel.font = messageFont
            headerView!.messageLabel.textColor = messageColor
            if let alignment = textAlignment {
                headerView!.messageLabel.textAlignment = alignment
            }
            setupPreferredMaxLayoutWidthForLabel(headerView!.messageLabel)
        }
        
    }
}
