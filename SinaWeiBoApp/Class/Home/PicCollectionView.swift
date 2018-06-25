//
//  PicCollectionView.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/16.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    var picURLs:[URL] = [URL]() {
        didSet {
            // 刷新数据
            self.reloadData()
        }
    }
    override func awakeFromNib() {
        dataSource = self
        delegate = self
    }
}

extension PicCollectionView:AnitmatorPresentDelegate {
    func startRect(indexPath: IndexPath) -> CGRect {
        // 获取cell
        let cell = self.cellForItem(at: indexPath)!
        // 获取开始位置的frame
        let startFrame = self.convert(cell.frame, to: UIApplication.shared.keyWindow)
        return startFrame
    }
    
    func endRect(indexPath: IndexPath) -> CGRect {
        // 获取image对象
        let picUrl = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)
        // 计算结束后的frame
        let w = UIScreen.main.bounds.width
        let h = w / (image?.size.width)! * (image?.size.height)!
        var y : CGFloat = 0
        if  h > UIScreen.main.bounds.height {
            y = 0
        } else {
            y = (UIScreen.main.bounds.height - h) * 0.5
        }
        return CGRect(x: 0, y: y, width: w, height: h)
    }
    
    func imageView(indexPath: IndexPath) -> UIImageView {
        // 创建imageView对象
        let imageView = UIImageView()
        // 获取image对象
        let picUrl = picURLs[indexPath.item]
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)
        // 设置imageView属性
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.clipsToBounds = true
        return imageView
    }
}

extension PicCollectionView:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "PicCell", for: indexPath) as! PicCollectionViewCell
        // 给cell添加数据
        cell.picUrl = picURLs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 获取通知需要传递的参数
        let userInfo = [showPhotoIndextPathKey:indexPath,showPhotoUrlsKey:picURLs] as [String : Any]
        // 创建通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: showPhotoBrowserNote), object: self, userInfo: userInfo)
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    var picUrl:URL? {
        didSet {
            iconImage.contentMode = .scaleAspectFill
            iconImage.clipsToBounds = true
            iconImage.sd_setImage(with: picUrl, placeholderImage: nil)
        }
    }
    /** 图片*/
    @IBOutlet weak var iconImage: UIImageView!
    
}
