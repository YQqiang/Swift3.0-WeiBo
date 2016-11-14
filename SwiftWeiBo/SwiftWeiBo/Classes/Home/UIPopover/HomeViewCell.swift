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
class HomeViewCell: UITableViewCell {

    // MARK:- 控件的属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    // MARK:- 约束的属性
    @IBOutlet weak var contentLabelWCons: NSLayoutConstraint!
    
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
            sourceLabel.text = viewModel.sourceText
            //8.设置正文内容
            contentLabel.text = viewModel.status?.text
            //9.设置昵称的颜色
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        //1.设置正文的宽度约束
        contentLabelWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
