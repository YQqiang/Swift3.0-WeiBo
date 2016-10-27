//
//  TitleButton.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/27.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class TitleButton: UIButton {

    // MARK:- 重写初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    //Swift中规定,重写控件的init(frame: CGRect) 或者init()方法,必须重写init?(coder aDecoder: NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.frame.origin.x = 0
        imageView?.frame.origin.x = (titleLabel?.frame.size.width)! + 5
    }

}
