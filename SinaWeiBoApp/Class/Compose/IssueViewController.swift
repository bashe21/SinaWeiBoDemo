//
//  IssueViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2017/1/20.
//  Copyright © 2017年 Mr Zhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class IssueViewController: UIViewController {

    // MARK: - 属性
    lazy var issueTitleView:IssueTitleView = IssueTitleView()
    lazy var images:[UIImage] = [UIImage]()
    lazy var emoticonVc:EmoticonController = EmoticonController.init { [weak self] (emoticon) in
        self!.textView.insertEmoticon(emoticon: emoticon)
        self!.textViewDidChange(self!.textView)
    }
    @IBOutlet weak var textView: IssueTextView!
    @IBOutlet weak var picPickView: PicPickerView!
    // MARK: - 约束属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picCollectionHCons: NSLayoutConstraint!
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupNotification()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
// MARK: - UI设置
extension IssueViewController {
    func setupNavigationBar() {
        // 设置左侧item
        let leftItemBtn = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(IssueViewController.closeItemClick))
        navigationItem.leftBarButtonItem = leftItemBtn
        // 设置右侧Item
        let rightItemBtn = UIBarButtonItem.init(title: "发布", style: .plain, target: self, action: #selector(IssueViewController.issueItemClick))
        rightItemBtn.isEnabled = false
        navigationItem.rightBarButtonItem = rightItemBtn
        // 设置titleView
        issueTitleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = issueTitleView
    }
    func setupNotification() {
        // 键盘弹出监听
        NotificationCenter.default.addObserver(self, selector: #selector(IssueViewController.UIKeyboardWillChangeFrame(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        // 图片添加监听
        NotificationCenter.default.addObserver(self, selector: #selector(IssueViewController.addPicture), name: NSNotification.Name(rawValue: picAddPhotoNote), object: nil)
        // 图片删除
        NotificationCenter.default.addObserver(self, selector: #selector(IssueViewController.removePicture), name: NSNotification.Name(picRemovePhotoNote), object: nil)
    }
}
// MARK: - 事件监听
extension IssueViewController {
    func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func issueItemClick() {
        // 关闭键盘
        textView.resignFirstResponder()
        // 获取发送微博的微博正文
        let statusText = textView.getEmoticonString()
        let finishedCallBack = { (isSuccess : Bool) in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: nil)
        }
        if let image = images.first {
            NetworingTools.shareInstance.sendMessage(statusText: statusText, image: image, isSuccess: finishedCallBack)
        }
        else {
            // 发送微博
            NetworingTools.shareInstance.sendMessage(statusText: statusText, isSuccess: finishedCallBack)
        }
    }
    
    func UIKeyboardWillChangeFrame(notification:Notification) {
        // 获取动画执行时间
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        // 获取键盘最终离底部高度
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        // 计算工具栏离底部的高度
        let margin = UIScreen.main.bounds.height - y
        // 执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    // 弹出图片选择视图
    @IBAction func picPickerBtnClick(_ sender: UIButton) {
        textView.resignFirstResponder()
        picCollectionHCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 1.0 ) {
            self.view.layoutIfNeeded()
        }
    }
    // 弹出emotion视图
    @IBAction func emotionBtnClick(_ sender: UIButton) {
        // 退出键盘
        textView.resignFirstResponder()
        // 切换键盘
        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        // 弹出键盘
        textView.becomeFirstResponder()
    }
    
}
// MARK: - 图片添加与删除
extension IssueViewController {
    func addPicture() {
        // 判断图片来源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        // 创建照片选择控制器
        let ipc = UIImagePickerController()
        // 设置照片来源
        ipc.sourceType = .photoLibrary
        // 设置代理
        ipc.delegate = self
        // 弹出照片控制器
        present(ipc, animated: true, completion: nil)
    }
    func removePicture(note:NSNotification) {
        // 获取要删除的图片
        guard let image = note.object as? UIImage else {
            return
        }
        // 获取删除图片下标
        guard let index = images.index(of: image) else {
            return
        }
        // 从images删除该图片
        images.remove(at: index)
        // 重新赋值collectionView的images
        picPickView.images = images
    }
}
// MARK: - 照片选择控制器代理
extension IssueViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // 保存选择的图片到images数组
        images.append(image)
        // 将选中图片数组传递给collectionView
        picPickView.images = images
        // 退出图片选择控制器
        picker.dismiss(animated: true, completion: nil)
    }
}
// MARK: - UITextView代理
extension IssueViewController:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placlHoderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
