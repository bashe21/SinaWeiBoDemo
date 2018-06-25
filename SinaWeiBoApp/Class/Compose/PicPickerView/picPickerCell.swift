//
//  picPickerCell.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/22.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

class picPickerCell: UICollectionViewCell {
    // MARK: - 控件属性
    @IBOutlet weak var picAddPhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var picRemovePhotoBtn: UIButton!
    // MARK: - 自定义属性
    var image:UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                picAddPhotoBtn.isUserInteractionEnabled = false
                picRemovePhotoBtn.isHidden = false
            }
            else {
                imageView.image = nil
                picAddPhotoBtn.isUserInteractionEnabled = true
                picRemovePhotoBtn.isHidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    // 添加照片
    @IBAction func picPickerBtnClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(picAddPhotoNote), object: nil)
    }
    // 删除照片
    @IBAction func picRemovePhotoBtnClick(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(picRemovePhotoNote), object: imageView.image)
    }
    

}
