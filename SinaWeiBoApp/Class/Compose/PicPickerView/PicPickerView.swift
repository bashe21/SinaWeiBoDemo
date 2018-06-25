//
//  PicPickerView.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/22.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

let picPicker:String = "picPicker"
private let edgeMargin:CGFloat = 10

class PicPickerView: UICollectionView {
    // 图片数组
    var images:[UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        // 注册cell
        register(UINib.init(nibName: "picPickerCell", bundle: nil), forCellWithReuseIdentifier: picPicker)
        // cell属性设置
        let layout:UICollectionViewFlowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: (UIScreen.main.bounds.width - edgeMargin * 4)/3, height: (UIScreen.main.bounds.width - edgeMargin * 4)/3)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
        // 设置内边距
        contentInset = UIEdgeInsetsMake(edgeMargin, edgeMargin, 0, edgeMargin)
        
    }
    
}

extension PicPickerView:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPicker, for: indexPath) as! picPickerCell
        cell.backgroundColor = UIColor.red
        cell.image = indexPath.item < images.count ? images[indexPath.item] : nil
        return cell
    }
}
