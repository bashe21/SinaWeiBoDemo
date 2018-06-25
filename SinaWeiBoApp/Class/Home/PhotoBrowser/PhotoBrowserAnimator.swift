//
//  PhotoBrowserAnimator.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/2/6.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
// 面向协议开发
protocol AnitmatorPresentDelegate {
    func startRect(indexPath:IndexPath) ->CGRect
    func endRect(indexPath:IndexPath) ->CGRect
    func imageView(indexPath:IndexPath) ->UIImageView
}

protocol AnimatorDismissDelegate {
    func indexPathForDisimss() ->NSIndexPath
    func imageViewForDisimss() ->UIImageView
}

class PhotoBrowserAnimator: NSObject {
    var isPresented:Bool = false
    var presentDelegate:AnitmatorPresentDelegate?
    var dismissDelegate: AnimatorDismissDelegate?
    var indexPath:NSIndexPath?
}
// MARK: - 自定义转场代理的方法
extension PhotoBrowserAnimator:UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.isPresented = false
        return self
    }
}
// MARK: - 弹出和消失视图代理方法
extension PhotoBrowserAnimator:UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.isPresented ? animateForPresentView(using: transitionContext) : animateForDismissView(using: transitionContext)
    }
    // 弹出动画
    func animateForPresentView(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presentDelegate = presentDelegate,let indexPath = indexPath else {
            return
        }
        // 获取弹出的动画
        let presentView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        // 将弹出的view添加到containView中
        transitionContext.containerView.addSubview(presentView)
        // 获取执行动画的imageview
        let startRect = presentDelegate.startRect(indexPath: indexPath as IndexPath)
        let imageView = presentDelegate.imageView(indexPath: indexPath as IndexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = startRect
        // 执行动画
        presentView.alpha = 0.0
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            imageView.frame = presentDelegate.endRect(indexPath: indexPath as IndexPath)
        }) { (_) in
            imageView.removeFromSuperview()
            presentView.alpha = 1.0
            transitionContext.completeTransition(true)
        }
    }
    // 消失动画
    func animateForDismissView(using transitionContext: UIViewControllerContextTransitioning) {
        // nil值校验
        guard let presentDelegate = presentDelegate,let dismissDelegate = dismissDelegate else {
            return
        }
        // 获取消失的动画
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        dismissView.removeFromSuperview()
        // 获取执行动画的imageView
        let imageView = dismissDelegate.imageViewForDisimss()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDisimss()
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            //dismissView.alpha = 0.0
            imageView.frame = presentDelegate.startRect(indexPath: indexPath as IndexPath)
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
