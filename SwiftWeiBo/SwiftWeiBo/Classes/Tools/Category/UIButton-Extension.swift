//
//  UIButton-Extension.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/27.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

extension UIButton {
    //Swift 中以Class开头的方法是类方法, 类似OC中的+加号方法
    /*
    class func createButton(imageName: String, bgImageName: String) -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .normal)
        btn.setBackgroundImage(UIImage(named: bgImageName), for: .highlighted)
        btn.sizeToFit()
        return btn
    }
    */
    
    //convenience: 使用convince修饰的构造函数叫做便利构造函数.
    //便利构造函数通常用在对系统的类进行构造函数的扩充时使用.
    /*
     便利构造函数的特点
     1.便利构造函数通常写在extension里面
     2.便利构造函数init前需要加convenience
     3.在便利构造函数中需要明确的调用self.init()
     */
    convenience init(imageName: String, bgImageName: String) {
        self.init()
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    
    convenience init(bgColor: UIColor, fontSize: CGFloat, title: String) {
        self.init()
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    }
}
