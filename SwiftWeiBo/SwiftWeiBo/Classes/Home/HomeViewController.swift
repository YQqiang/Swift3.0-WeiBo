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
    lazy var titleButton: TitleButton = TitleButton()
    
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
        popoverVC.transitioningDelegate = self
        //4.弹出控制器
        present(popoverVC, animated: true) { 
            
        }
    }
}

//MARK:- 代理方法
extension HomeViewController: UIViewControllerTransitioningDelegate {
    //目的: 改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationViewController(presentedViewController: presented, presenting: presenting)
    }
    //目的: 自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    //    目的: 自定义消失的动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

//MARK:- 弹出和消失动画的代理方法
extension HomeViewController: UIViewControllerAnimatedTransitioning {
    // MARK:- 动画执行时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // MARK:- 获取转场的上下文: 可以通过转场上下文获取弹出的View 和消失的View
    //
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext) : animationForDismissedView(transitionContext)
    }
    
    // 自定义弹出动画
    func animationForPresentedView(_ transitionContext: UIViewControllerContextTransitioning) {
        //1.获取弹出的View
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        //2.将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView!)
        //3.执行动画
        presentedView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            presentedView?.transform = CGAffineTransform.identity
            }) { (_) in
                //必须告诉转场上下文你已经完成动画
                transitionContext.completeTransition(true)
        }
    }
    
    // 自定义消失动画
    func animationForDismissedView(_ transitionContext: UIViewControllerContextTransitioning) {
        //1.获取消失的view
        let dismissView = transitionContext.view(forKey: .from)
        //2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.0000)
            }) { (_) in
                transitionContext.completeTransition(true)
        }
    }
}





