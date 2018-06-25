//
//  ViewController.swift
//  表情的显示
//
//  Created by 张哈哈 on 2017/2/4.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var demoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = "用了这款护手霜之后男票老是牵着人家的手不肯放[爱你]这么好的东西当然要分享给大家[酷]领券下单更优惠哦"
        demoLabel.attributedText = FindEmoticon.shareInstance.findAttrString(statusText: str, font: demoLabel.font)
    }


}

