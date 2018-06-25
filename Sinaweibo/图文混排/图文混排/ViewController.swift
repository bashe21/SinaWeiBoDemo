//
//  ViewController.swift
//  图文混排
//
//  Created by 张哈哈 on 2017/1/25.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let attr1 = NSAttributedString.init(string: "小马哥", attributes: [NSForegroundColorAttributeName:UIColor.red])
        let attr2 = NSAttributedString.init(string: "IT教育", attributes: [NSForegroundColorAttributeName:UIColor.blue])
        let attachment = NSTextAttachment()
        attachment.image = UIImage.init(named: "d_aini")
        let font = textLabel.font
        attachment.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        let imgAttr = NSAttributedString.init(attachment: attachment)
        let attr = NSMutableAttributedString()
        attr.append(attr1)
        attr.append(imgAttr)
        attr.append(attr2)
        textLabel.attributedText = attr
    }

}

