//
//  PhotoBrowserCell.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/19.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserViewCellDelegate: NSObjectProtocol {
    func imageClick()
}

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
            progressView.isHidden = false
            imageView.sd_setImage(with: getBigURL(smallUrl: picUrl), placeholderImage: image, options: [], progress: {
                (current, total) -> Void in
                self.progressView.process = CGFloat(current) / CGFloat(total)
            }, completed: {
                (image, _, _, _) -> Void in
                self.progressView.isHidden = true
                self.imageView.image = image
            })
            scrollView.contentSize = CGSize(width: 0, height: height)
        }
    }
    
    var delegate: PhotoBrowserViewCellDelegate?
    
    // MARK:- 懒加载属性
    fileprivate lazy var scrollView: UIScrollView = UIScrollView()
    fileprivate lazy var progressView: ProgressView = ProgressView()
    lazy var imageView: UIImageView = UIImageView()
    
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
        contentView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        scrollView.frame = contentView.bounds
        scrollView.frame.size.width -= 20
        progressView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        
        //监听imageView的点击
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickImageViewAction))
        imageView.addGestureRecognizer(tap)
    }
    fileprivate func getBigURL(smallUrl: URL) -> (URL) {
        let smallUrlStr = smallUrl.absoluteString
        let bigUrlStr = smallUrlStr.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL(string: bigUrlStr)!
    }
    @objc fileprivate func clickImageViewAction() {
        delegate?.imageClick()
    }
}

