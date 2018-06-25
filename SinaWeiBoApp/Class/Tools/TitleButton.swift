//
//  TitleButton.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/20.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit

class TitleButton: UIButton {
    // MARK: - 重写init函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(UIImage.init(named: "navigationbar_arrow_down"), for: .normal)
        setImage(UIImage.init(named: "navigationbar_arrow_up"), for: .selected)
        setTitle("coderwhy", for: .normal)
        setTitleColor(UIColor.black, for: .normal)
        sizeToFit()
    }
    // swift规定，重写函数的init()或者init(frame方法)，必须重写init?(coder aDecoder: NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel!.frame.origin.x = 0
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }
}
