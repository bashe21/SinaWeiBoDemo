//
//  Status.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/13.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class Status: NSObject {

    // MARK: - 属性
    var text:String? // 微博内容
    var created_at:String? // 微博创建时间
    var mid:Int = 0  // 微博id
    var source:String? //微博来源
    var user:User?
    var pic_urls:[[String:String]]? // 配图数据
    var retweeted_status:Status? // 微博的转发微博
    // 自定义构造函数
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
        // 将用户字典转换成用户模型
        if let userDict = dict["user"] as? [String:AnyObject] {
            user = User.init(dict: userDict)
        }
        // 将转发微博专用成微博模型
        if let retweetedStatusDict = dict["retweeted_status"] as? [String:AnyObject] {
            retweeted_status = Status.init(dict: retweetedStatusDict)
        }
        
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
