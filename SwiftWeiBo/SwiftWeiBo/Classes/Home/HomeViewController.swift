//
//  HomeViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/25.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    // MARK:- 属性
    var isPresented = false
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleButton: TitleButton = TitleButton()
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录时设置的内容
        visistorView.addRotationAnim()
        if !isLogin {
            return
        }
        //2.设置导航栏内容
        setupNavigationBar()
    }
}

// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //设置标题
        titleButton.setTitle("逆行云", for: .normal)
        titleButton.addTarget(self, action: #selector(HomeViewController.clickTitleBtn(sender:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
}

//MARK:- 事件监听
extension HomeViewController {
    @objc fileprivate func clickTitleBtn(sender: TitleButton) {
        //1.改变按钮状态
        sender.isSelected = !sender.isSelected
        //2.创建弹出的控制器
        let popoverVC = PopViewController()
        //3.设置控制器的modal样式
        popoverVC.modalPresentationStyle = .custom
        //设置转场的代理
        popoverVC.transitioningDelegate = popoverAnimator
        //4.弹出控制器
        present(popoverVC, animated: true) { 
            
        }
    }
}







