//
//  HomeViewCell.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/14.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SDWebImage
import KILabel

private let edgeMargin:CGFloat = 15
private let itemMargin:CGFloat = 10

class HomeViewCell: UITableViewCell {

    // MARK: - 控件属性
    @IBOutlet weak var avtorView: UIImageView!
    @IBOutlet weak var vertifyView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var creatAtView: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var reweetContentLabel: UILabel! 
    @IBOutlet weak var retweetBgView: UIView!
    @IBOutlet weak var bottomToolView: UIView!
    // MARK: - 约束的属性
    @IBOutlet weak var contentLabelCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    @IBOutlet weak var retweetContentTopCons: NSLayoutConstraint!
    // MARK: - 自定义属性
    var viewModel:StatusViewModel? {
        didSet {
            // nil值校验
            guard let viewModel = viewModel else {
                return
            }
            // 设置头像
            avtorView.sd_setImage(with: viewModel.profileUrl, placeholderImage: UIImage.init(named: "avatar_default_small"))
            // 设置认证头像
            vertifyView.image = viewModel.verifiedImage
            // 设置昵称
            screenNameLabel.text = viewModel.status?.user?.screen_name
            // 设置昵称颜色
            screenNameLabel.textColor = viewModel.mbrankImage == nil ? UIColor.black : UIColor.orange
            // 设置用户等级
            vipView.image = viewModel.mbrankImage
            // 设置发布时间
            creatAtView.text = viewModel.createAtText
            // 设置来源
            sourceLabel.text = viewModel.sourceText
            // 设置内容
            contentLabel.attributedText = FindEmoticon.shareInstance.findAttrString(statusText: viewModel.status?.text, font: contentLabel.font)
            // 配图尺寸计算
            let picViewSize = calculatePicViewSize(count: viewModel.picURLs.count)
            picViewHCons.constant = picViewSize.height
            picViewWCons.constant = picViewSize.width
            // 将配图数据传递给picCollectionView
            picView.picURLs = viewModel.picURLs
            // 设置微博转发正文
           if let screenName = viewModel.status?.retweeted_status?.user?.screen_name,let reweetText = viewModel.status?.retweeted_status?.text {
                let reweetText = "@" + "\(screenName):" + reweetText
                reweetContentLabel.attributedText = FindEmoticon.shareInstance.findAttrString(statusText: reweetText, font: reweetContentLabel.font)
                retweetBgView.isHidden = false
                // 设置有转发微博是正文距离顶部约束
                retweetContentTopCons.constant = 15
            }
           else {
                reweetContentLabel.text = nil
                retweetBgView.isHidden = true
                // 设置有转发微博是正文距离顶部约束
                retweetContentTopCons.constant = 0
            }
            // 获取cell高度
            // 强制布局
            layoutIfNeeded()
            if viewModel.cellHeight == 0 {
                viewModel.cellHeight = bottomToolView.frame.maxY
            }
        }
    }
    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // 微博正文宽度约束
        contentLabelCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
    }
}

extension HomeViewCell {
    func calculatePicViewSize(count:Int) ->CGSize {
        // 没有图片
        if count == 0  {
            // 设置没有配图距离底部的约束
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        // 设置有配图距离底部的约束
        picViewBottomCons.constant = 10
        if count == 1 {
            let urlString = viewModel?.picURLs.last?.absoluteString
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: urlString)
            // 设置layout
            let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.itemSize = CGSize.init(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
            return CGSize.init(width: (image?.size.width)! * 2, height: (image?.size.height)! * 2)
        }
        // 计算item的高度和宽度
        let itemWH = (UIScreen.main.bounds.width - 2 * edgeMargin - 2 * itemMargin) / 3
        
        // q其他数量layout
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        // 4张图片
        if count == 4 {
            let picViewWH = itemWH * 2 + itemMargin + 1
            return CGSize.init(width: picViewWH, height: picViewWH)
        }
        // 4张以上
        let rows = CGFloat((count - 1) / 3 + 1)
        let picViewH = rows * itemWH + (rows - 1) * itemMargin
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        return CGSize.init(width: picViewW, height: picViewH)
    }
}






