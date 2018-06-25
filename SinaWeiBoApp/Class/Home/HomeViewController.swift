//
//  HomeViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/15.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BasicViewController {

    // MARK: - 懒加载属性
    lazy var titleBtn:TitleButton = TitleButton.init()
    lazy var statuses:[StatusViewModel] = [StatusViewModel]()
    lazy var tipLabel:UILabel = UILabel()
    lazy var photoBrowserAnimatior:PhotoBrowserAnimator = PhotoBrowserAnimator()
    // 注意：在闭包中如果使用当前对象属性或者方法要加self
    // 两个地方需要加self：1>如果在一个函数中出现歧义，2>在闭包中如果使用当前对象属性或者方法
    lazy var popoverAnimator : PopoverAnimator = PopoverAnimator.init { [weak self](present) in
        self?.titleBtn.isSelected = present
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        vistorView.addRotationAni()
        setupNavigationBar()
        // 请求数据
        setupHeaderView()
        // 请求更多数据
        setupFooterView()
        // 添加tipLabel
        setupTipLabel()
        setupNotification()
        // 根据cell约束动态计算其cell高度
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
// MARK: - 设置UI界面
extension HomeViewController {
    func setupNavigationBar()  {
        // 设置左边item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention")
        // 设置右边item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")
        // 设置中间titleview
        titleBtn.addTarget(self, action: #selector(HomeViewController.titleBtnClick), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    func setupHeaderView() {
        // 创建headerView
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadNewStatuses))
        // 设置headerview属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放刷新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        self.tableView = UITableView.init()
        self.tableView.mj_header = header
        // 加载最新数据
        self.tableView.mj_header.beginRefreshing()
    }
    func setupFooterView() {
        super.tableView.mj_footer = MJRefreshAutoFooter.init(refreshingTarget: self, refreshingAction: #selector(HomeViewController.loadMoreStatus))
    }
    func setupTipLabel() {
        // 添加label到导航栏
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        // 设置label的frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.size.width, height: 34)
        // 设置label的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.showPhotoBrowser(note:)), name: NSNotification.Name(rawValue: showPhotoBrowserNote), object: nil)
    }
}

// MARK: - 事件监听函数
extension HomeViewController {
    func titleBtnClick() {
        // 创建控制器
        let popverVc = PopoverViewController()
        // 设置控制器modal样式
        popverVc.modalPresentationStyle = .custom
        // 设置控制器转场代理
        popverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentedFrame = CGRect.init(x: 100, y: 55, width: 180, height: 250)
        // 弹出控制器
        present(popverVc, animated: true, completion: nil)
    }
    func showPhotoBrowser(note:NSNotification) {
        // 取出数据
        let indexPath = note.userInfo![showPhotoIndextPathKey] as! NSIndexPath
        let picUrls = note.userInfo![showPhotoUrlsKey] as! [NSURL]
        let objc = note.object as! PicCollectionView
        // 创建视图控制器
        let photoBrowserVc = PhotoBrowserViewController.init(indexPath: indexPath, picUrls: picUrls)
        // modal样式
        photoBrowserVc.modalPresentationStyle = .custom
        // 设置转场代理
        photoBrowserVc.transitioningDelegate = photoBrowserAnimatior
        // 设置动画代理
        photoBrowserAnimatior.presentDelegate = objc
        photoBrowserAnimatior.indexPath = indexPath
        photoBrowserAnimatior.dismissDelegate = photoBrowserVc
        // modal出控制器
        present(photoBrowserVc, animated: true, completion: nil)
    }
}

// MARK: - 请求数据
extension HomeViewController {
    func loadNewStatuses() {
        loadStatuses(isNewData: true)
    }
    // 加载更多数据
    func loadMoreStatus() {
        loadStatuses(isNewData: false)
    }
    
    func loadStatuses(isNewData:Bool) {
        // 获取当前微博id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = statuses.first?.status?.mid ?? 0
        }
        else {
            max_id = statuses.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 :max_id - 1
        }
        NetworingTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            guard let statusArray = result else {
                return
            }
            var tempViewModels = [StatusViewModel]()
            // 遍历微博对应的字典
            for dict in statusArray {
                let status = Status.init(dict: dict)
                let viewModel = StatusViewModel.init(status: status)
                tempViewModels.append(viewModel)
            }
            if isNewData {
                self.statuses = tempViewModels + self.statuses
            }
            else {
                self.statuses += tempViewModels
            }
            // 缓存图片
            self.cacheImage(viewModels: tempViewModels)
        }
    }
    func cacheImage(viewModels:[StatusViewModel]) {
        let group = DispatchGroup.init()
        for viewModel in viewModels {
            for picUrl in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) in
                    group.leave()
                })
            }
        }
        group.notify(queue: DispatchQueue.main) {
            // 刷新数据
            self.tableView.reloadData()
            // 结束刷新
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            // 显示提示的label
            self.showTipLabel(count: viewModels.count)
        }
    }
    func showTipLabel(count:Int) {
        // 设置tiplabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新的微博" :"\(count)条新微薄"
        // 执行动画
        UIView.animate(withDuration: 1.0, animations: {
            self.tipLabel.frame.origin.y = 44
        }) { (_) in
            UIView.animate(withDuration: 1.0, delay: 1.5, options: [], animations: { 
                self.tipLabel.frame.origin.y = 10
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
        }
    }
}

extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statuses.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        // 设置传递给cell的数据
        cell.viewModel = statuses[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let viewModel = statuses[indexPath.row]
        return viewModel.cellHeight
    }
}




