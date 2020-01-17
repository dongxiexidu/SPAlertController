//
//  SPInterfaceActionItemSeparatorView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2019/11/27.
//  Copyright © 2019 lidongxi. All rights reserved.
//

import UIKit

class SPInterfaceActionItemSeparatorView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = SP_LINE_COLOR
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.backgroundColor = self.frame.size.height > SP_LINE_WIDTH ? UIColor.gray.withAlphaComponent(0.15) : SP_LINE_COLOR
    }

}
