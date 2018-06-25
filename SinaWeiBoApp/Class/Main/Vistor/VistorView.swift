//
//  VistorView.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/20.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

class VistorView: UIView {
    //MARK:- 快速通过xib创建类的方法
    class func vistorView() -> VistorView {
        return Bundle.main.loadNibNamed("VistorView", owner: nil, options: nil)?.first as! VistorView
    }
    //MARK:- 控件的属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipView: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    //MARK:- 自定义函数
    func setupVistorViewInfo(iconName:String,title:String) {
        rotationView.isHidden = true
        iconView.image = UIImage.init(named: iconName)
        tipView.text = title
    }
    func addRotationAni()  {
        // 创建动画
        let rotationAni:CABasicAnimation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        // 设置动画属性
        rotationAni.fromValue = 0
        rotationAni.toValue = M_PI * 2
        rotationAni.repeatCount = MAXFLOAT
        rotationAni.duration = 10
        rotationAni.isRemovedOnCompletion = false
        // 添加动画到layer
        rotationView.layer.add(rotationAni, forKey: nil)
    }
}
