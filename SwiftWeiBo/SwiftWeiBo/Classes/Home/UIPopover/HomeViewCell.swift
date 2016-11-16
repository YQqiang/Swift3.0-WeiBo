//
//  HomeViewCell.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/14.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin: CGFloat = 15
private let itemMargin: CGFloat = 10

class HomeViewCell: UITableViewCell {

    // MARK:- 控件的属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var retweetedContentLabel: UILabel!
    @IBOutlet weak var retweetedBgView: UIView!
    @IBOutlet weak var bottomToolView: UIView!
    
    // MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var retweetedContentLabelTopCons: NSLayoutConstraint!
    
    // MARK:- 自定义属性
    var viewModel: StatusViewModel? {
        didSet {
            //1.nil值校验
            guard let viewModel = viewModel else {
                return
            }
            //2.设置头像
            iconView.sd_setImage(with: viewModel.profileURL, placeholderImage: #imageLiteral(resourceName: "avatar_default"))
            //3.设置认证的图标
            verifiedView.image = viewModel.verifiedImage
            //4.设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            //5.设置会员等级图标
            vipView.image = viewModel.vipImage
            //6.设置时间显示
            timeLabel.text = viewModel.createAtText
            //7.设置来源
            if let sourceText = viewModel.sourceText {
                sourceLabel.text = "来自 " + sourceText
            } else {
                sourceLabel.text = nil
            }
            //8.设置正文内容
            contentLabel.attributedText = FindEmoticon.shareIntance.findAttrString(viewModel.status?.text, font: contentLabel.font)
            //9.设置昵称的颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            //10.计算picView的宽度和高度约束
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewHCons.constant = picViewSize.height
            picViewWCons.constant = picViewSize.width
            //11.将picURL数据传递给picView
            picView.picUrls = viewModel.picURLs
            //12.设置转发微博的正文
            if viewModel.status?.retweeted_status != nil {
                //12.1设置转发微博的正文
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, let retweetedText = viewModel.status?.retweeted_status?.text {
                    retweetedContentLabel.text = "@" + "\(screenName):" + retweetedText
                    retweetedContentLabelTopCons.constant = 15
                }
                //12.2设置背景显示
                retweetedBgView.isHidden = false
            } else {
                retweetedContentLabel.text = nil
                retweetedBgView.isHidden = true
                retweetedContentLabelTopCons.constant = 0
            }
            //13.计算cell的高度
            if viewModel.cellHeight == 0 {
                //13.1强制布局
                layoutIfNeeded()
                //13.2获取底部工具栏的最大Y值
                viewModel.cellHeight = bottomToolView.frame.maxY
            }
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //1.设置正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }
}

// MARK:- 计算方法
extension HomeViewCell {
    fileprivate func calculatePicViewSize(count: Int) -> CGSize {
        //1.没有配图
        if count == 0 {
            return CGSize(width: 0, height: 0)
        }
        //2.取出pieView对应的layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        //3. 单张配图
        if count == 1 {
            //3.1取出图片
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            //3.2设置一张图片是itemsize
            layout.itemSize = CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            return CGSize(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
        }
        //4.计算出来imageViewWH
        let imageViewWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        //5.设置其他张配图时layout的itemSize
        layout.itemSize = CGSize(width: imageViewWH, height: imageViewWH)
        //6.四张配图
        if count == 4 {
            let picViewWH = imageViewWH * 2 + itemMargin + 1
            return CGSize(width: picViewWH, height: picViewWH)
        }
        //7.其他张配图
        //7.1 计算行数
        let rows = CGFloat((count - 1) / 3 + 1)
        //7.2 计算picView的高度
        let picViewH = rows * imageViewWH + (rows - 1) * itemMargin
        //7.3 计算picView的宽度
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        
        return CGSize(width: picViewW, height: picViewH)
    }
}






