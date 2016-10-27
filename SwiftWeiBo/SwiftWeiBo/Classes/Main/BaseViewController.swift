//
//  BaseViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/26.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController {

    // MARK:- 懒加载属性
    lazy var visistorView = VisitorView.visitorView()
    
    // MARK:- 定义变量
    var isLogin: Bool = true
    
    // MARK:- 系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setupVisitorView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
    }

}

//MARK:- 设置UI界面
extension BaseViewController {
    fileprivate func setupVisitorView() {
        view = visistorView
        visistorView.registerBtn.addTarget(self, action: #selector(BaseViewController.registerAction), for: .touchUpInside)
        visistorView.loginBtn.addTarget(self, action: #selector(BaseViewController.loginAction), for: .touchUpInside)
    }
    //设置导航栏左右的item
    fileprivate func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("注册", comment: ""), style: .plain, target: self, action: #selector(BaseViewController.registerAction))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("登录", comment: ""), style: .plain, target: self, action: #selector(BaseViewController.loginAction))
    }
}

//MARK:- 事件监听
extension BaseViewController {
    @objc fileprivate func registerAction() {
        print("点击注册按钮")
    }
    @objc fileprivate func loginAction() {
        print("点击登录按钮")
    }
}

