//
//  VisitorView.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/26.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    // MARK:- 提供一种快速通过xib创建的类方法
    class func visitorView() -> VisitorView {
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)!.first as! VisitorView
    }
    
    // MARK:- 控件的属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK:- 自定义函数
    func setupVisitorViewInfo(_ iconName: String, title: String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.isHidden = true
    }
    
    func addRotationAnim() {
        //1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        //2.设置动画属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.isRemovedOnCompletion = false
        
        //3.将动画添加到layer中
        rotationView.layer.add(rotationAnim, forKey: nil)
    }
    
}
