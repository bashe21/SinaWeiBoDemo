//
//  BasicViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/20.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

class BasicViewController: UITableViewController {
    //MARK:- 懒加载属性
    lazy var vistorView:VistorView = VistorView.vistorView()
    //MARK:- 定义变量
    var isLogin:Bool = UserAccountViewModel.shareInstance.isLogin
    //MARK:- 系统回调函数
    override func loadView() {
        isLogin ? super.loadView() : setupVistorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        
    }
}
// MARK: - 设置UI界面
extension BasicViewController {
    // 设置访客视图
    func setupVistorView() {
        view = vistorView
        // 监听访客视图中“登录”和“注册”按钮点击事件
        vistorView.registerBtn.addTarget(self, action: #selector(BasicViewController.registerBtnClick), for: .touchUpInside)
        vistorView.loginBtn.addTarget(self, action: #selector(BasicViewController.loginBtnClick), for: .touchUpInside)
    }
    // MARK: - 设置导航栏左右两侧的item
    func setupNavigationItems()  {
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(BasicViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(BasicViewController.loginBtnClick))
    }
}
// MARK: - 事件监听
extension BasicViewController {
    func registerBtnClick() {
        print("registerBtnClick")
    }
    func loginBtnClick() {
        let oauthVC = OAuthViewController()
        let oauthNav = UINavigationController.init(rootViewController: oauthVC)
        present(oauthNav, animated: true, completion: nil)
    }
}
