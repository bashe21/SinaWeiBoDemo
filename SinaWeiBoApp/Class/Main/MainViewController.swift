//
//  MainViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/15.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    // 懒加载属性
    lazy var imageNames = ["tabbar_home_highlighted","tabbar_message_center_highlighted","","tabbar_discover_highlighted","tabbar_profile_highlighted"];
    lazy var composeBtn:UIButton = UIButton.init(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")//UIButton.createButtomWithImage(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    override func viewDidLoad() {
        super.viewDidLoad()
//        addChildViewController(childVc: HomeViewController(), title: "首页", image: "tabbar_home_selected", seletedImage: "tabbar_home_selected")
//        addChildViewController(childVc: HomeViewController(), title: "发现", image: "tabbar_discover_selected", seletedImage: "tabbar_discover_selected")
//        addChildViewController(childVc: HomeViewController(), title: "消息", image: "tabbar_message_center_selected", seletedImage: "tabbar_message_center_selected")
//        addChildViewController(childVc: HomeViewController(), title: "我", image: "tabbar_profile_selected", seletedImage: "tabbar_profile_selected")
        setupComposeBtn()
    }
    // swift支持方法的重载
    // 方法的重载：方法的名称相同，但是参数不同 1、参数类型不同；2、参数的个数不同
    // private在当前文件夹可以访问，其他文件不能访问
//    private func addChildViewController(childVc: UIViewController,title:String,image:String,seletedImage:String) {
//        // 设置子控制器属性
//        childVc.title = title
//        childVc.tabBarItem.image = UIImage.init(named: image)
//        childVc.tabBarItem.selectedImage = UIImage.init(named: seletedImage)
//        // 包装导航栏控制器
//        let childNav = UINavigationController.init(rootViewController: childVc)
//        //添加控制器
//        addChildViewController(childNav)
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTabBar()
    }
}
// MARK:- 设置UI界面
extension MainViewController {
    // 设置发布按钮
    func setupComposeBtn() {
        // 将composeBtn添加到tabbar中
        tabBar.addSubview(composeBtn)
        // 设置位置
        composeBtn.center = CGPoint.init(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        // 监听发布按钮的点击
        // Selector写法：1>#selector(MainViewController.componseBtnClick)
        composeBtn.addTarget(self, action: #selector(MainViewController.componseBtnClick), for: .touchUpInside)
    }
    
    func setupTabBar() {
        // 遍历所有的item
        for i in 0..<tabBar.items!.count {
            // 获取item
            let item = tabBar.items![i]
            if i == 2 {
                // 如果下标值为2，则该item不可与用户交互
                item.isEnabled = false
                continue
            }
            // 设置其他item选中时的状态
            item.selectedImage = UIImage.init(named: imageNames[i])
            
        }
    }
}
//MARK:- 事件监听
extension MainViewController {
    //事件监听本质是发送消息，但发送消息是oc的特性
    //将方法包装成@SEL-->类中查找方法列表-->根据@SEL找到imp指针(函数指针)-->执行函数
    //如果swift中将函数声明为private，那么该函数不会添加到方法列表中
    //如果在private前面加加上修饰@objc，那么该函数会被添加到方法列表中
    func componseBtnClick() {
        // 创建视图控制器
        let issue = IssueViewController()
        // 包装导航控制器
        let nav = UINavigationController.init(rootViewController: issue)
        // 跳转发布界面
        present(nav, animated: true, completion: nil)
        
        
        
        
        
        
        
    }
}
