//
//  PhotoBrowserCell.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/2/5.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate:NSObjectProtocol {
    func imageViewClick()
}

class PhotoBrowserCell: UICollectionViewCell {
    // MARK: - 懒加载属性
    lazy var scrollView:UIScrollView = UIScrollView()
    lazy var imageView:UIImageView = UIImageView()
    lazy var progressView:ProgressView = ProgressView()
    // MARK: - 自定义属性
    var picUrl:NSURL? {
        didSet {
            setupContent(picUrl: picUrl)
        }
    }
    var delegate : PhotoBrowserCellDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 设置UI界面
extension PhotoBrowserCell {
    func setupUI() {
        // 添加view
        contentView.addSubview(scrollView)
        contentView.addSubview(progressView)
        scrollView.addSubview(imageView)
        // 设置frame
        scrollView.frame = contentView.bounds
        //scrollView.frame.size.width -= 20
        progressView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        progressView.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        // 设置progress属性
        progressView.isHidden = true
        progressView.backgroundColor = UIColor.clear
        // 添加手势
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(PhotoBrowserCell.imageViewClick))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled  = true
    }
}
// MARK: - 事件监听
extension PhotoBrowserCell {
    func imageViewClick() {
       delegate?.imageViewClick()
    }
}
// MARK: - 私有方法
extension PhotoBrowserCell {
    func setupContent(picUrl:NSURL?) {
        // nil值判断
        guard let picUrl = picUrl else {
            return
        }
        // 获取image
        let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: picUrl.absoluteString)
        // 计算imageview的frame
        let width = contentView.bounds.width
        let height = width/(image?.size.width)! * (image?.size.height)!
        var y:CGFloat = 0
        if height > UIScreen.main.bounds.height {
            y = 0
        }
        else {
            y = (UIScreen.main.bounds.height - height) * 0.5
        }
        // 设置imageview的frame
        imageView.frame = CGRect(x: 0, y: y, width: width, height: height)
        progressView.isHidden = false
        // 设置imageview的iamge
        imageView.sd_setImage(with: getBigImage(smallUrl: picUrl), placeholderImage: image, options: [], progress: { (current, total) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        // 设置scrollView的范围
        scrollView.contentSize = CGSize(width: 0, height: imageView.frame.height)
    }
    
    func getBigImage(smallUrl:NSURL) -> URL {
        let smallUrlString = smallUrl.absoluteString
        let bigUrlString = smallUrlString?.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        return URL.init(string: bigUrlString!)!
        
    }
}
