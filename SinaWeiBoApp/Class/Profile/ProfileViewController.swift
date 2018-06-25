//
//  ProfileViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/15.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

class ProfileViewController: BasicViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        vistorView.setupVistorViewInfo(iconName: "visitordiscover_image_profile", title: "登录后，你的微薄、相册、个人资料会显示在这里，展示给别人")
    }

}
