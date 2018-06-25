//
//  FindEmoticon.swift
//  表情的显示
//
//  Created by 张哈哈 on 2017/2/4.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class FindEmoticon: NSObject {
    // 创建单例对象
    static let shareInstance:FindEmoticon = FindEmoticon()
    // 表情属性
    lazy var manager:EmoticonManger = EmoticonManger()
    // 查找属性字符串的方法
    func findAttrString(statusText:String,font:UIFont) -> NSMutableAttributedString? {
        // 创建正则表达式
        let pattern = "\\[.*?\\]"
        // 创建正则表达式对象
        guard let regex = try? NSRegularExpression.init(pattern: pattern, options: []) else {
            return nil
        }
        // 匹配
        let results = regex.matches(in: statusText, options: [], range: NSRange.init(location: 0, length: statusText.characters.count))
        // 遍历结果
        let attrMString = NSMutableAttributedString.init(string: statusText)
        for i in (0..<results.count).reversed(){
            // 获取结果
            let result = results[i]
            // 获取chs
            let chs = (statusText as NSString).substring(with: result.range)
            // 根据chs获取图片路径
            guard let pngPath = findPngpath(chs: chs) else {
                return nil
            }
            // 创建属性字符串
            let attachment = NSTextAttachment()
            attachment.image = UIImage.init(contentsOfFile: pngPath)
            attachment.bounds = CGRect.init(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
            let attrImgString = NSAttributedString.init(attachment: attachment)
            attrMString.replaceCharacters(in: result.range, with: attrImgString)
        }
        return attrMString
    }
    private func findPngpath(chs:String) -> String? {
        for package in manager.packages {
            for emoticon in package.emoticons {
                if emoticon.chs == chs {
                    return emoticon.pngPath
                }
            }
        }
        return nil
    }
}
