//
//  StatusViewModel.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/14.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {

    var cellHeight:CGFloat = 0 // cell高度
    var status:Status?
    // MARK: - 对数据处理的属性
    var sourceText:String? // 数据来源
    var createAtText:String? // 创建时间
    var verifiedImage:UIImage? // 认证类型
    var mbrankImage:UIImage? // 会员级别
    var profileUrl:URL?
    var picURLs:[URL] = [URL]() // 微博配图数据
    init(status:Status) {
        self.status = status
        // 对来源进行处理
        if let source = status.source, source != "" {// nil校验
            // 获取文本位置
            let startIndex = (source as NSString).range(of: ">").location + 1
            let length = (source as NSString).range(of: "</").location - startIndex
            // 获取文本
            sourceText = (source as NSString).substring(with: NSRange.init(location: startIndex, length: length))
        }
        // 对创建时间进行处理
        if let cretate_at = status.created_at  {// nil校验
            // 对时间处理
            createAtText = NSDate.createDateString(createAt: cretate_at)
        }
        // 对用户认证类型进行处理
        let verified_type = status.user?.verified_type ?? -1
        switch verified_type {
        case 0:
            verifiedImage = UIImage.init(named: "avatar_vip")
        case 2,3,5:
            verifiedImage = UIImage.init(named: "avatar_enterprise_vip_gray")
        case 220:
            verifiedImage = UIImage.init(named: "avatar_grassroot")
        default:
            verifiedImage = UIImage.init(named: "avator_default")
        }
        // 处理会员图标
        let mbrank = status.user?.mbrank ?? 0
        if mbrank > 0 && mbrank < 7 {
            mbrankImage = UIImage.init(named: "common_icon_membership_level\(mbrank)")
        }
        // 用户头像地址处理
        let profileString = status.user?.profile_image_url ?? ""
        profileUrl = URL.init(string: profileString)
        // 微博配图数据处理
        let picURLDicts = (status.pic_urls?.count)! != 0 ? status.pic_urls : status.retweeted_status?.pic_urls
        if let picURLDicts = picURLDicts {
            for picURLDict in picURLDicts {
                guard let picURLString = picURLDict["thumbnail_pic"] else {
                    continue
                }
                picURLs.append(URL.init(string: picURLString)!)
            }
        }
    }
}
