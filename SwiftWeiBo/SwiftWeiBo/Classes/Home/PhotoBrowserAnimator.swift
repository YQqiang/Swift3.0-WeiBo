//
//  PhotoBrowserAnimator.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/19.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class PhotoBrowserAnimator: NSObject {
    var isPresented = false
}

extension PhotoBrowserAnimator: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        return self
    }
}

extension PhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissView(transitionContext: transitionContext)
    }
    func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        //1.取出弹出的view
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        //2.将presentedview添加到containerview中
        transitionContext.containerView.addSubview(presentedView!)
        //3.执行动画
        presentedView?.alpha = 0.0
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            () -> Void in
            presentedView?.alpha = 1.0
        }, completion: {
            (_) -> Void in
            transitionContext.completeTransition(true)
        })
        
    }
    func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        //1.取出消失的view
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        //2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            () -> Void in
            dismissView?.alpha = 0.0
        }, completion: {
            (Bool) -> Void in
            dismissView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
