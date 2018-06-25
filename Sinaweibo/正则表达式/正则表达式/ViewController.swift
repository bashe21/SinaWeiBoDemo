//
//  ViewController.swift
//  正则表达式
//
//  Created by 张哈哈 on 2017/2/4.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
/*
 练习1：匹配abc
 练习2：包含一个a~z，后面必须是0-9，-->[a-z][0-9]或者[a-z]\d
 练习3：必须第一个是字母，第二个是数字 -->^[a-z][0-9]$
  * ^[a-z]:首字母必须是a-z
  * \d{2,10} :数字有2到10位
  * [a-z]$ : 表示必须以a-z的字母结尾
 练习4：必须第一个是字母，后面4~9是数字

 练习5：不能是数字0~9
  * [^0-9]: 不能是0~9
 练习6：QQ匹配 ^[0-9]{4-11}$
 都是数字
 5-12位
 并且第一位不能是0
 练习7：手机号码匹配
 以13/15/17/18开头
 长度为11位数字
 */
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let str = "13234455666"
        // 1 创建正则表达式
        let pattern = "^1[3578]\\d{9}$"
        // 创建正则表达式对象
        guard let regex = try?NSRegularExpression.init(pattern: pattern, options: []) else {
            return
        }
        // 匹配字符串中内容
        let results = regex.matches(in: str, options: [], range: NSRange.init(location: 0, length: str.characters.count))
        // 遍历数组，获取结果
        for result in results {
            print((str as NSString).substring(with: result.range))
            print(result.range)
        }
    }

}

