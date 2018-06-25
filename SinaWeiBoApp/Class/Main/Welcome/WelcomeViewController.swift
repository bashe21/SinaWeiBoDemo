//
//  WelcomeViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/5.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {

    // MARK: - 属性定义
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewBottomDistance: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置头像
        let urlString = UserAccountViewModel.shareInstance.account?.avatar_hd
        let url = URL.init(string: urlString ?? "")
        // ??: 如果？？前面的可选类型有值，那么将前面的可选类型解包并赋值
        // 如果前面的可选类型为nil，则将??后面的值进行赋值
        iconView.sd_setImage(with: url, placeholderImage: UIImage.init(named: "avatar_default_big"))
        // 改变约束的值
        iconViewBottomDistance.constant = UIScreen.main.bounds.size.height - 200;
        // 执行动画
        // dampimg:阻尼系数，阻尼系数越大，动画弹动的效果越不明显 0~1
        // UIViewAnimationOptions 初始化速度
        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIApplication.shared.keyWindow?.rootViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
}
