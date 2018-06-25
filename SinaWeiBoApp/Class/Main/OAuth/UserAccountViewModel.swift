//
//  UserAccountViewModel.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/3.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class UserAccountViewModel {
    static var shareInstance:UserAccountViewModel = UserAccountViewModel.init()
    // MARK: - 定义属性
    var account:UserAccount?
    var accountPath:String? {
        var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
        return accountPath
    }
    var isLogin:Bool {
        if account == nil {
            return false
        }
        if account?.expires_date == nil {
            return false
        }
        return account?.expires_date?.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    }
    init() {
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath!) as? UserAccount
    }
}
