//
//  NSDate-Extension.swift
//  test
//
//  Created by 张哈哈 on 2017/1/14.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import Foundation

extension NSDate {
    class func createDateString(createAt:String) -> String {
        // 创建格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en") as Locale!
        // 字符串转日期
        guard let createDate = fmt.date(from: createAt) else {
            return "";
        }
        // 创建当前时间
        let nowDate = Date()
        // 计算创建时间和当前时间的时间差
        let interval = Int(nowDate.timeIntervalSince(createDate))
        // 刚刚
        if interval < 60 {
            return "刚刚"
        }
        // 1小时以内
        if interval < 60 * 60 {
            return "\(interval / 60)分钟以前"
        }
        // 当天内
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时以前"
        }
        // 创建日历对象
        let calendar = Calendar.current
        // 昨天
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        // 1年内
        let cmps = calendar.dateComponents([.year], from: createDate, to: nowDate)
        if cmps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        // 超过一年
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
    }
}
