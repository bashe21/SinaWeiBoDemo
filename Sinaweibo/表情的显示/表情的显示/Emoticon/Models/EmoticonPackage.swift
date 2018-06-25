//
//  EmoticonPackage.swift
//  表情键盘
//
//  Created by 张哈哈 on 2017/1/24.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class EmoticonPackage: NSObject {

    var emoticons:[Emoticon] = [Emoticon]()
    init(id:String) {
        super.init()
        // 最近分组
        if id == "" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        if id == "com.sina.default" {
            addEmptyEmoticon(isRecently: true)
            return
        }
        // 根据id拼接content.plist路径
        let plistPath = Bundle.main.path(forResource: "\(id)/content.plist", ofType: nil, inDirectory: "Emoticons.bundle")!
        // 根据路径读取数据
        let dict = NSDictionary.init(contentsOfFile: plistPath)!
        let array = dict["emoticons"] as! [[String:String]]
        // 遍历数组
        var index = 0
        for var dict in array {
            if let png = dict["png"] {
                dict["png"] = id + "/" + png
            }
            emoticons.append(Emoticon.init(dict: dict))
            index += 1
            if index == 20 {
                // 添加删除按钮
                emoticons.append(Emoticon.init(isRemove: true))
                index = 0
            }
        }
        // 添加空白表情
        addEmptyEmoticon(isRecently: false)
    }
    
    private func addEmptyEmoticon(isRecently:Bool) {
        let count = emoticons.count % 21
        if count == 0 && !isRecently {
            return
        }
        for _ in count ..< 20 {
            emoticons.append(Emoticon.init(isEmpty: true))
        }
        emoticons.append(Emoticon.init(isRemove: true))
    }
}
