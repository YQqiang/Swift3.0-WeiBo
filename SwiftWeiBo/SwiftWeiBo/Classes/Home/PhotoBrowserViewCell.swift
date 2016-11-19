//
//  PhotoBrowserCell.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/19.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoBrowserViewCell: UICollectionViewCell {
    
    // MARK:- 定义属性
    var picUrl: URL? {
        didSet {
            //1.nil值校验
            guard let picUrl = picUrl else {
                return
            }
            //2.取出image对象
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)
            //3.计算imageView的frame
            let width = UIScreen.main.bounds.width
            let height = width / (image?.size.width)! * (image?.size.height)!
            var y : CGFloat = 0
            if height > UIScreen.main.bounds.height {
                y = 0
            } else {
                y = (UIScreen.main.bounds.height - height) * 0.5
            }
            imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
            
            // 4.设置imagView的图片
            
            
            
            imageView.image = image
        }
    }
    
    
    // MARK:- 懒加载属性
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    fileprivate lazy var imageView: UIImageView = UIImageView()
    fileprivate lazy var progressView: ProgressView = ProgressView()
    
    // MARK:- 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension PhotoBrowserViewCell {
    fileprivate func setupUI() {
        contentView.addSubview(scrollView)
        contentView.addSubview(imageView)
        contentView.addSubview(ProgressView)
        scrollView.frame = contentView.bounds
    }
}

