//
//  SendAlertView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/11.
//  Copyright © 2020 lidongxi. All rights reserved.
//

import UIKit

class SendAlertView: UIView,Nibloadable {
    
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    
    var contentImage: UIImage? {
        didSet{
            contentImageView.image = contentImage
            guard let img = contentImage else { return }
            var contentH: CGFloat = 0
            let imgRatio: CGFloat = img.size.height/img.size.width
            let contentW: CGFloat = bounds.size.width-30// 30是contentImageView的左右间距之和
            if img.size.height < contentW {
                contentH = img.size.height
            } else {
                contentH = imgRatio * contentW
            }
            if contentH > UIScreen.main.bounds.size.height-300 {
                contentH = UIScreen.main.bounds.size.height-300
            }
            // 更新图片的高度约束
            self.contentHeightConstraint.constant = contentH
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userIconView.layer.cornerRadius = 4.0
        userIconView.layer.masksToBounds = true
        textView.delegate = self
        textView.layer.borderWidth = 0.5/UIScreen.main.scale
//        textView.layer.borderColor = UIColor
//        textView.placeholder = "给朋友留言"
       // textView.placeholderColor = .l
        /*
        self.textView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor;
        self.textView.placeholder = @"给朋友留言";
        self.textView.placeholderColor = [UIColor lightGrayColor];
         */
    }
    
    
    
    
    
}

extension SendAlertView: UITextViewDelegate {
    
}
