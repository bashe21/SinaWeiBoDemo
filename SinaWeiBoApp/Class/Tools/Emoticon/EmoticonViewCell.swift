//
//  EmoticonViewCell.swift
//  表情键盘
//
//  Created by 张哈哈 on 2017/1/25.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class EmoticonViewCell: UICollectionViewCell {
    // 懒加载属性
    lazy var emoticonBtn : UIButton = UIButton()
    // 自定义属性
    var emoticon:Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            // 设置emoticon内容
            emoticonBtn.setImage(UIImage.init(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
            // 设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
            }
        }
    }
    // 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 设置UI
extension EmoticonViewCell {
    func setupUI() {
        // 添加表情按钮
        contentView.addSubview(emoticonBtn)
        // 设置表情按钮frame
        emoticonBtn.frame = contentView.bounds
        // 设置表情按钮属性
        emoticonBtn.isUserInteractionEnabled = false
    }
}
