//
//  UIButtom-Extension.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/19.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit
extension UIButton {
    /*
    /// swift中类方法是以class开头的方法
    class func createButtomWithImage(imageName:String,bgImageName:String) -> UIButton {
        // 创建btn
        let btn:UIButton = UIButton.init()
        // 设置btn属性
        btn.setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        btn.setBackgroundImage(UIImage.init(named: bgImageName + "_highlighted"), for: .highlighted)
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        return btn
    }
     */
    //convenience 便利，使用convenience修饰的函数叫便利构造函数
    //便利构造函数常用在对系统的类进行构造函数的扩充时使用
    //便利构造函数的特点：
    //1、便利构造函数通常都写在extension里面
    //2、便利构造函数init前面需加convenience
    //3、在便利构造函数中要明确的调用self.init()
    convenience init(imageName:String,bgImageName:String) {
        self.init()
        setBackgroundImage(UIImage.init(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage.init(named: bgImageName + "_highlighted"), for: .highlighted)
        setImage(UIImage.init(named: imageName), for: .normal)
        setImage(UIImage.init(named: imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
    }
    convenience init(bgColor:UIColor,fontSize:CGFloat,title:String) {
        self.init()
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setTitle(title, for: .normal)
    }
}
