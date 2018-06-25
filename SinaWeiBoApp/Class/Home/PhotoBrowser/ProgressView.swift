//
//  ProgressView.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/2/5.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    var progress:CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 获取参数
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = CGFloat(2 * M_PI) + startAngle
        let path = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        // 绘制到中心的线
        path.addLine(to: center)
        path.close()
        // 设置颜色
        UIColor.init(white: 1.0, alpha: 0.4).set()
        // 开始绘制
        path.fill()
    }
 

}
