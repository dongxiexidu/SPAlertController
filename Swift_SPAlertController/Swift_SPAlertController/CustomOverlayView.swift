//
//  CustomOverlayView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/17.
//  Copyright © 2020 HeFahu. All rights reserved.
//

import UIKit

class CustomOverlayView: UIView {

     // MARK: - Appearance

      /// Turns the blur of the overlay view on or off
      @objc public dynamic var blurEnabled: Bool {
          get { return !blurView.isHidden }
          set { blurView.isHidden = !newValue }
      }
      
      /// The blur radius of the overlay view
      @objc public dynamic var blurRadius: CGFloat {
          get { return blurView.blurRadius }
          set { blurView.blurRadius = newValue }
      }
      
      /// Whether the blur view should allow for
      /// live rendering of the background
      @objc public dynamic var liveBlurEnabled: Bool {
          get { return blurView.trackingMode == .common }
          set {
              if newValue {
                  blurView.trackingMode = .common
              } else {
                  blurView.trackingMode = .none
              }
          }
      }
      
      /// The background color of the overlay view
      @objc public dynamic var color: UIColor? {
          get { return overlay.backgroundColor }
          set { overlay.backgroundColor = newValue }
      }

      /// The opacity of the overlay view
      @objc public dynamic var opacity: CGFloat {
          get { return overlay.alpha }
          set { overlay.alpha = newValue }
      }

      // MARK: - Views

      internal lazy var blurView: DynamicBlurView = {
          let blurView = DynamicBlurView(frame: .zero)
          blurView.blurRadius = 8
          blurView.trackingMode = .none
          blurView.isDeepRendering = true
          blurView.tintColor = .clear
          blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
          return blurView
      }()

      internal lazy var overlay: UIView = {
          let overlay = UIView(frame: .zero)
          overlay.backgroundColor = .black
          overlay.alpha = 0.7
          overlay.autoresizingMask = [.flexibleHeight, .flexibleWidth]
          return overlay
      }()

      // MARK: - Inititalizers

      override init(frame: CGRect) {
          super.init(frame: frame)
          setupView()
      }

      required public init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }

      // MARK: - View setup

      fileprivate func setupView() {

          autoresizingMask = [.flexibleHeight, .flexibleWidth]
          backgroundColor = .clear
          alpha = 0

          addSubview(blurView)
          addSubview(overlay)
      }

}
