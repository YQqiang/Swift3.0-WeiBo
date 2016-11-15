//
//  ComposeTextView.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/15.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {
    
    // MARK:- 懒加载属性
    fileprivate lazy var placeHolderLabel: UILabel = UILabel()

    // MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
}

// MARK:- 设置UI界面
extension ComposeTextView {
    fileprivate func setupUI() {
        //1.添加子控件
        addSubview(placeHolderLabel)
        //2.设置frame
        placeHolderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        //3.设置placeHolder的属性
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = font
        //4.设置placeHolder的文字
        placeHolderLabel.text = "随时随地发现新鲜事,发微博吧..."
        //5.设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
    }
}
