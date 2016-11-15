//
//  ComposeViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/15.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    // MARK:- 懒加载属性
    fileprivate lazy var composeTitleView: ComposeTitleView = ComposeTitleView()
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

// MARK:- 设置UI界面
extension ComposeViewController {
    fileprivate func setupNavigationBar() {
        //1.左侧关闭按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        //2.右侧发布按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(sendItemClick))
        //3.设置标题
        composeTitleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = composeTitleView
    }
}

// MARK:- 事件监听
extension ComposeViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func sendItemClick() {
        print("sendItemClick")
    }
}


