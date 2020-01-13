//
//  CommodityListView.swift
//  Swift_SPAlertController
//
//  Created by lidongxi on 2020/1/13.
//  Copyright © 2020 HeFahu. All rights reserved.
//

import UIKit

class CommodityListView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = self.bounds
        let imageViewW: CGFloat = bounds.size.width/2-20
        let imageViewH: CGFloat = bounds.size.height
        var imageViewY: CGFloat = 0
        if #available(iOS 11, *) {
            imageViewY = self.safeAreaInsets.top
        }
        var lastImageView: UIImageView!
        for (index,imgView) in imageViews.enumerated() {
            imgView.frame = CGRect.init(x: (imageViewW + 10.0) * CGFloat(index), y: imageViewY, width: imageViewW, height: imageViewH)
            if index == self.imageViews.count-1 {
                lastImageView = imgView
            }
        }
        scrollView.contentSize = CGSize.init(width: lastImageView.frame.maxX, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageViews = [UIImageView]()
    let images = ["image0.jpg", "image1.jpg", "image2.jpg", "image3.jpg", "image4.jpg", "image5.jpg", "image6.jpg", "image7.jpg", "image8.jpg", "image9.jpg"]
    
    lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.backgroundColor = UIColor.init(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        scrollV.showsVerticalScrollIndicator = false
        
        for (index,imgName) in images.enumerated() {
            let imageView = UIImageView.init(image: UIImage.init(named: imgName))
            imageView.backgroundColor = .red
            scrollV.addSubview(imageView)
            imageViews.append(imageView)
        }
        return scrollV
    }()
}
