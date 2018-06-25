//
//  AppDelegate.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/15.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var defaultVc:UIViewController {
        let isLogin = UserAccountViewModel.shareInstance.isLogin
        return isLogin ? WelcomeViewController() : UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 设置全局颜色
        UITabBar.appearance().tintColor = UIColor.orange
        UINavigationBar.appearance().tintColor = UIColor.orange
        // 创建window
        window = UIWindow.init(frame:  UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = defaultVc
        return true
    }

}

