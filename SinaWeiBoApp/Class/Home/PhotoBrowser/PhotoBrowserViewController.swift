//
//  PhotoBrowserViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/2/4.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

let photoBrowserCell = "photoBrowserCell"

class PhotoBrowserViewController: UIViewController {

    // MARK: - 懒加载属性
    lazy var collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: PhotoBrowserFlowLayout())
    lazy var closeBtn:UIButton = UIButton.init(bgColor: UIColor.darkGray, fontSize: 14, title: "关闭")
    lazy var saveBtn:UIButton = UIButton.init(bgColor: UIColor.darkGray, fontSize: 14, title: "保存")
    // MARK: - 定义属性
    var indexPath : NSIndexPath
    var picUrls : [NSURL]
    // MARK: - 自定义构造函数
    init(indexPath:NSIndexPath,picUrls:[NSURL]) {
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func loadView() {
//        super.loadView()
//        view.frame.size.width += 20
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI界面
        setupUI()
        // 滚动到对应的图片
        collectionView.scrollToItem(at: indexPath as IndexPath, at: .left, animated: false)
    }
}

extension PhotoBrowserViewController {
    func setupUI() {
        // 添加view
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        // 设置frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        // 设置collectview属性
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserCell)
        collectionView.dataSource = self
        // 设置按钮属性
        closeBtn.addTarget(self, action: #selector(PhotoBrowserViewController.closeBtnClick), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(PhotoBrowserViewController.saveBtnClick), for: .touchUpInside)
    }
}
// MARK: - 事件监听
extension PhotoBrowserViewController {
    func closeBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    func saveBtnClick() {
        // 获取当前正在显示的cell的图片
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        guard let image = cell.imageView.image else {
            return
        }
        // 保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(PhotoBrowserViewController.image(image:error:contextInfo:)), nil)
    }
    func image(image:UIImage,error:NSError?,contextInfo:AnyObject) {
        var showString = ""
        if error != nil {
            showString = "保存失败"
        } else {
            showString = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showString)
    }
}

// MARK: - collection代理方法
extension PhotoBrowserViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserCell, for: indexPath) as! PhotoBrowserCell
        // 设置cell数据
        cell.picUrl = picUrls[indexPath.item]
        cell.delegate = self
        // 返回cell
        return cell
    }
}
// MARK: - PhotoBrowserCell代理
extension PhotoBrowserViewController:PhotoBrowserCellDelegate {
    func imageViewClick() {
        closeBtnClick()
    }
}
// MARK: - 遵守AnimatorDismissDelegate 
extension PhotoBrowserViewController:AnimatorDismissDelegate {
    func indexPathForDisimss() -> NSIndexPath {
        let cell = collectionView.visibleCells.first!
        return collectionView.indexPath(for: cell)! as NSIndexPath
    }
    func imageViewForDisimss() -> UIImageView {
        // 创建imageview
        let imageView:UIImageView = UIImageView()
        // 设置imageview的frame
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        imageView.frame = cell.imageView.frame
        imageView.image = cell.imageView.image
        // 设置imageview的属性
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
// MARK: - 自定义collectionView布局
class PhotoBrowserFlowLayout:UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        // 设置itemSize
        itemSize = UIScreen.main.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}






