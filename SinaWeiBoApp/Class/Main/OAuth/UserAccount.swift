//
//  UserAccount.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/31.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import Foundation

class UserAccount: NSObject,NSCoding {
    // MARK: - 属性
    /** 授权凭证*/
    var access_token:String?
    /** 过期日期->秒*/
    var expires_in:Double = 0 {
        didSet {
            expires_date = NSDate.init(timeIntervalSinceNow: expires_in)
        }
    }
    /** 用户uid*/
    var uid:String?
    /** 过期日期*/
    var expires_date:NSDate?
    /** 用户头像*/
    var avatar_hd:String?
    /** 用户昵称*/
    var screen_name:String?
    // 重写init构造函数
    init(dict:[String:AnyObject]) {
        super.init()
        setValuesForKeys(dict)
    }
    // 重写
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    // 重写description属性
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token","expires_date","uid","avatar_hd","screen_name"]).description
    }
    // 解档数据
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_hd = aDecoder.decodeObject(forKey: "avatar_hd") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    // 归档数据
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(avatar_hd, forKey: "avatar_hd")
        aCoder.encode(screen_name, forKey: "screen_name")
    }
}
