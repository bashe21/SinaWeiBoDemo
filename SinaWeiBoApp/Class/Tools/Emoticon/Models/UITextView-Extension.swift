//
//  UITextView-Extension.swift
//  表情键盘
//
//  Created by 张哈哈 on 2017/2/3.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

extension UITextView {
    // 获取textview属性字符串，对应的表情字符串
    func getEmoticonString() -> String {
        // 获取textview属性文本
        let attrMStr = NSMutableAttributedString.init(attributedString: attributedText)
        // 遍历属性文本
        attrMStr.enumerateAttributes(in: NSRange.init(location: 0, length: attrMStr.length), options: []) { (dict, range, _) in
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.chs!)
            }
        }
        return attrMStr.string
    }
    // 插入表情符号
    func insertEmoticon(emoticon:Emoticon) {
        // 空白按钮
        if emoticon.isEmpty {
            return
        }
        // 删除按钮
        if emoticon.isRemove {
            deleteBackward()
            return
        }
        // emoji表情
        if emoticon.emojiCode != nil {
            // 获取光标所在位置
            let textRange = selectedTextRange!
            // 替换光标位置为emoji表情
            replace(textRange, withText: emoticon.emojiCode!)
            return
        }
        // 图文混排
        // 1 根据图片路径创建属性字符串
        let attachment = EmoticonAttachment()
        attachment.chs = emoticon.chs
        attachment.image = UIImage.init(contentsOfFile: emoticon.pngPath!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let imageAttrStr = NSAttributedString.init(attachment: attachment)
        // 创建可变的属性字符串
        let attrMStr = NSMutableAttributedString.init(attributedString: attributedText)
        // 添加图片到文本
        // 获取光标所在位置
        let range = selectedRange
        attrMStr.replaceCharacters(in: selectedRange, with: imageAttrStr)
        // 设置textview属性文本
        attributedText = attrMStr
        // 重新设置文字大小
        self.font = font
        // 重新定位光标位置 + 1
        selectedRange = NSRange.init(location: range.location + 1, length: 0)
    }
}
