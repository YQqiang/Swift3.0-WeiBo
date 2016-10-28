//
//  PopoverAnimator.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/28.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    var isPresented = false
}

//MARK:- 代理方法
extension PopoverAnimator: UIViewControllerTransitioningDelegate {
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
extension PopoverAnimator: UIViewControllerAnimatedTransitioning {
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
            dismissView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 0.00001)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
