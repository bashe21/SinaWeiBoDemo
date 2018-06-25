//
//  EmoticonManger.swift
//  表情键盘
//
//  Created by 张哈哈 on 2017/1/24.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class EmoticonManger: NSObject {

    var packages:[EmoticonPackage] = [EmoticonPackage]()
    
    override init() {
        // 添加最近的表情包
        packages.append(EmoticonPackage.init(id: ""))
        // 添加默认的表情包
        packages.append(EmoticonPackage.init(id: "com.sina.normal"))
        // 添加emoji的表情包
        packages.append(EmoticonPackage.init(id: "com.apple.emoji"))
        // 添加浪小花的表情包
        packages.append(EmoticonPackage.init(id: "com.sina.default"))
        
    }
}
