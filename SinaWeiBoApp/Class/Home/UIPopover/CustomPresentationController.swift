//
//  CustomPresentationController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/21.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

class CustomPresentationController: UIPresentationController {
    // MARK: - 自定义属性
    lazy var coverView:UIView = UIView.init()
    var presentedFrame : CGRect = CGRect.zero
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = presentedFrame
        // 添加蒙版
        setupCoverView()
    }
}

// MARK: - 设置UI
extension CustomPresentationController {
    func setupCoverView() {
        // 添加蒙版
        containerView?.insertSubview(coverView, belowSubview: presentedView!)
        // 设置蒙版属性
        // 设置背景颜色
        coverView.backgroundColor = UIColor.init(white: 0.8, alpha: 0.4)
        // 设置frame
        coverView.frame = containerView!.bounds
        // 添加手势
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(CustomPresentationController.coverViewClick))
        coverView.addGestureRecognizer(gesture)
    }
}

// MARK: - 事件监听
extension CustomPresentationController {
    func coverViewClick() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
