//
//  EmoticonController.swift
//  表情键盘
//
//  Created by 张哈哈 on 2017/1/24.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit

let emotionCell = "emotionCell"

class EmoticonController: UIViewController {

    var emotionCallBack:(_ emoticon:Emoticon)->()
    // 懒加载
    lazy var collectionView:UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: EmoticonViewFlowLayout())
    lazy var toolBar:UIToolbar = UIToolbar()
    lazy var manger : EmoticonManger = EmoticonManger()
    
    init(emotionCallBack:@escaping (_ emoticon:Emoticon)->()) {
        self.emotionCallBack = emotionCallBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // 准备collectionView
        prepareForCollectionView()
        // 准备toolBar
        prepareForToolBar()
    }
    
    private func prepareForCollectionView() {
        // 注册cell
        collectionView.register(EmoticonViewCell.self, forCellWithReuseIdentifier: emotionCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    private func prepareForToolBar() {
        // 添加item
        var index = 0
        let titles = ["最近","默认","emoji","浪小花"]
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(itemClick(item:)))
            item.tag = index
            index += 1
            tempItems.append(item)
            tempItems.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        // 添加toolBar的items
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orange
    }
    @objc private func itemClick(item:UIBarButtonItem) {
        // 获取点击item的tag
        let tag = item.tag
        // 获取indexPath
        let indexPath = IndexPath.init(item: 0, section: tag)
        // 滚动到对应的表情
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

extension EmoticonController {
    func setupUI() {
        // 添加视图
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        let views = ["toolBar":toolBar,"collectionView":collectionView] as [String : Any]
        // 设置frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft,.alignAllRight], metrics: nil, views: views)
        // 添加约束
        view.addConstraints(cons)
        collectionView.backgroundColor = UIColor.white
        toolBar.backgroundColor = UIColor.red
    }
}
// MARK: - collectionView数据源和代理方法
extension EmoticonController:UICollectionViewDataSource,UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let packages = manger.packages.count
        return packages
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let packages = manger.packages
        let emotions = packages[section].emoticons
        return emotions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 获取cell
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: emotionCell, for: indexPath)) as! EmoticonViewCell
        // 设置cell数据
        //cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.red : UIColor.purple
        let package = manger.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        cell.emoticon = emoticon
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 取出点击的表情
        let package = manger.packages[indexPath.section]
        let emotion = package.emoticons[indexPath.item]
        // 将点击表情插入到最近分组中
        insertRecentlyEmoticon(emoticon: emotion)
        // 将表情回调给外部控制器
        emotionCallBack(emotion)
    }
    
    private func insertRecentlyEmoticon(emoticon:Emoticon) {
        // 如果是空表情或删除按钮不要插入
        if emoticon.isEmpty || emoticon.isRemove {
            return
        }
        // 删除一个表情
        if (manger.packages.first?.emoticons.contains(emoticon))! { // 原来有这个表情
            let index = (manger.packages.first?.emoticons.index(of: emoticon))!
            manger.packages.first?.emoticons.remove(at: index)
        } else { // 原来有这个表情
            manger.packages.first?.emoticons.remove(at: 19)
        }
        // 将emotion插入到最近分组中
        manger.packages.first?.emoticons.insert(emoticon, at: 0)
    }
}

class EmoticonViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        // 计算itemWH
        let itemWH = UIScreen.main.bounds.width / 7
        // 设置layout属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        // 设置collectionView属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        let edgeMargin = (collectionView!.bounds.height - itemWH * 3) / 2
        collectionView?.contentInset = UIEdgeInsets(top: edgeMargin, left: 0, bottom: edgeMargin, right: 0)
    }
}















