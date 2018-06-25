//
//  IssueTextView.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/20.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SnapKit

class IssueTextView: UITextView {

    lazy var placlHoderLabel:UILabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

}

// MARK: - 设置UI
extension IssueTextView {
    func setupUI() {
        // 添加label
        addSubview(placlHoderLabel)
        // 设置frame
        placlHoderLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(6)
            make.left.equalTo(self).offset(8)
        }
        // 设置文字内容和颜色和字体大小
        placlHoderLabel.textColor = UIColor.lightGray
        placlHoderLabel.text = "分享新鲜事..."
        placlHoderLabel.font = font
        // 设置内边距
        textContainerInset = UIEdgeInsetsMake(4, 7, 0, 7)
    }
}
