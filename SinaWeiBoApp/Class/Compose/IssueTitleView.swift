//
//  IssueTitleView.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/20.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SnapKit

class IssueTitleView: UIView {
    // MARK: - 懒加载属性
    lazy var titleLabel:UILabel = UILabel()
    lazy var screenNameLabel:UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 设置UI
extension IssueTitleView {
    func setupUI() {
        // 添加label
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        // 设置label约束
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
        }
        // 设置控件属性
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        // 设置控件文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name
    }
}
