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
    //注意: 在闭包中如果使用当前对象的属性或者调用方法,也需要加self
    //两个地方需要使用self: 1> 如果在一个函数中出现歧义; 2> 在闭包中使用当前对象的属性或者调用方法.
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self!.titleButton.isSelected = presented
    }
    fileprivate lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录时设置的内容
        visistorView.addRotationAnim()
        if !isLogin {
            return
        }
        //2.设置导航栏内容
        setupNavigationBar()
        //3.请求数据
        loadStatuses()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
}

// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //设置标题
        titleButton.setTitle("逆行云", for: .normal)
        titleButton.addTarget(self, action: #selector(HomeViewController.clickTitleBtn(_:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
}

//MARK:- 事件监听
extension HomeViewController {
    @objc fileprivate func clickTitleBtn(_ sender: TitleButton) {
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

// MARK:- 请求数据
extension HomeViewController {
    fileprivate func loadStatuses() {
        NetWorkTools.shareInstance.loadStatuses { (result, error) in
            //1.校验错误
            if error != nil {
                print(error!)
                return
            }
            //2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            //3.遍历微博对应的字典
            for statusDic in resultArray {
                let status = Status(dic: statusDic)
                let viewModel = StatusViewModel(status: status)
                self.viewModels.append(viewModel)
//                print(statusDic)
            }
            //4.刷新单元格
            self.tableView.reloadData()
        }
    }
}

// MARK:- tableView 的数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        //2.给cell设置数据
        let viewModel = viewModels[indexPath.row]
        cell.viewModel = viewModel
        return cell
    }
}




