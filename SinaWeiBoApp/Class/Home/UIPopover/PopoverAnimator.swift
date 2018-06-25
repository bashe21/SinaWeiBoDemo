//
//  PopoverAnimator.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/22.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {
    // MARK: - 自定义属性
    var isPresented:Bool = false
    var presentedFrame : CGRect = CGRect.zero
    
    var callBack: ((_ present:Bool) -> ())?
    // MARK: - 自定义构造函数
    // 如果自定义了一个构造函数，但是没有对默认的init()重写，那么自定义的函数会覆盖默认的init()构造函数
    init(callBack:@escaping (_ present:Bool) -> ()) {
        self.callBack = callBack
    }
}
// MARK: - 自定义转场代理的方法
extension PopoverAnimator:UIViewControllerTransitioningDelegate {
    // 目的：改变弹出view的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presention = CustomPresentationController.init(presentedViewController: presented, presenting: presenting)
        presention.presentedFrame = presentedFrame
        return presention
    }
    // 目的：自定义弹出动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        callBack!(isPresented)
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = false
        callBack!(isPresented)
        return self
    }
}
// MARK: - 弹出和消失视图代理方法
extension PopoverAnimator:UIViewControllerAnimatedTransitioning {
    // 设置动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    // 获取弹出和消失的动画视图
    // UITransitionContextFromViewKey 获取消失视图
    // UITransitionContextToViewKey 获取弹出视图
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? animateedForPresentedView(using: transitionContext) : animatedForDismissedView(using: transitionContext)
    }
    // 自定义弹出动画
    func animateedForPresentedView(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取弹出的视图
        let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        presentedView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0)
        // 将弹出的view加到containerview中
        transitionContext.containerView.addSubview(presentedView)
        // 执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {() -> Void in
            presentedView.transform = CGAffineTransform.identity
        }, completion: {(_) -> Void in
            // 必须告诉上下文你已经完成动画
            transitionContext.completeTransition(true)
        })
    }
    // 自定义消失动画
    func animatedForDismissedView(using transitionContext: UIViewControllerContextTransitioning)  {
        // 获取消失的视图
        let dismissView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {() -> Void in
            dismissView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
        }, completion: {(_) -> Void in
            dismissView.removeFromSuperview()
            // 必须告诉上下文你已经完成动画
            transitionContext.completeTransition(true)
        })
    }
}
