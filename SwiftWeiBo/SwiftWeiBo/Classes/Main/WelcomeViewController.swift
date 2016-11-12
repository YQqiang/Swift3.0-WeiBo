//
//  WelcomeViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/10.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // MARK:- 拖线的属性
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var iconView: UIImageView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //0.设置头像
        let profileUrlString = UserAccountModel.shareIntance.account?.avatar_large
        // ?? : 如果 ?? 前面的可选类型有值,那么将前面的可选类型解包并赋值
        // 如果 ?? 前面的可选类型为nil , 那么使用 ?? 后面的值
        let url = URL(string: profileUrlString ?? "")
        iconView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "avatar_default_big"))
        
        //1.改变约束的值
        iconViewBottomCons.constant = UIScreen.main.bounds.height - 200
        //2.执行动画
        //Damping 阻力系数: 阻力系数越大,弹动的效果越不明显 0~1
        //initialSpringVelocity 初始化速度
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (_) -> Void in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
}
