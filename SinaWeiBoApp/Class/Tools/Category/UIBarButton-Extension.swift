//
//  UIBarButton-Extension.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/20.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    /*convenience init(imageName:String) {
        self.init()
        let btn:UIButton = UIButton.init()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.customView = btn
    }*/
    convenience init(imageName:String) {
        let btn:UIButton = UIButton.init()
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        self.init(customView:btn)
    }
}
