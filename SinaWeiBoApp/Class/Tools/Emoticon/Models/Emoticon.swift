//
//  Emoticon.swift
//  表情键盘
//
//  Created by 张哈哈 on 2017/1/24.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class Emoticon: NSObject {

    // MARK: - 定义属性
    var code : String? {     // emoji的code
        didSet {
            guard let code = code else {
                return
            }
            // 创建扫描器
            let scanner = Scanner.init(string: code)
            // 调用扫描器，扫描code中的值
            var value:UInt32 = 0
            scanner.scanHexInt32(&value)
            // 将value转换成字符串
            let c = Character.init(UnicodeScalar.init(value)!)
            // 将字符转换成字符串
            emojiCode = String.init(c)
        }
    }
    var png : String? {      // 普通表情对应的图片名称
        didSet {
            guard let png = png else {
                return
            }
            pngPath = Bundle.main.bundlePath + "/Emoticons.bundle/" + png
        }
    }
    var chs : String?       // 普通表情对应的文字
    // MARK: - 数据处理
    var pngPath : String?
    var emojiCode : String?
    var isRemove : Bool = false
    var isEmpty : Bool = false
    // MARK: - 自定义构造函数
    init(dict:[String:String]) {
        super.init()
        setValuesForKeys(dict)
    }
    
    init(isRemove:Bool) {
        self.isRemove = isRemove
    }
    
    init(isEmpty:Bool) {
        self.isEmpty = isEmpty
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
    override var description: String {
        return dictionaryWithValues(forKeys: ["emojiCode","pngPath","chs"]).description
    }
}
