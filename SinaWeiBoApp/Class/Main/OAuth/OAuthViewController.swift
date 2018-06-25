//
//  OAuthViewController.swift
//  SinaWeiBoApp
//
//  Created by 张哈哈 on 2016/12/29.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // MARK: - 控件的属性
    @IBOutlet weak var webView: UIWebView!
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置导航栏
        setupNavigationBar()
        // 加载网页
        loadPage()
    }
}
// MARK: - 设置UI界面相关
extension OAuthViewController {
    func setupNavigationBar()  {
        // 设置左侧的itme
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeBtnClick))
        // 设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "填充", style: .plain, target: self, action: #selector(OAuthViewController.fillBtnClick))
        // 设置标题
        title = "登录页面"
    }
    func loadPage()  {
        // 获取登录页面的urlstring
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(App_Key)&redirect_uri=\(redirect_uri)"
        // 获取对应的url
        guard let url = NSURL.init(string: urlString) else {
            return
        }
        // 穿件url对应的request对象
        let urlRequst = NSURLRequest.init(url: url as URL)
        // 加载登录页面
        webView.loadRequest(urlRequst as URLRequest)
    }
}
// MARK: - 事件监听函数
extension OAuthViewController {
    func closeBtnClick()  {
        dismiss(animated: true, completion: nil)
    }
    func fillBtnClick() {
        // 书写js代码 JavaScript
        let jsCode = "document.getElementById('userId').value='253039877@qq.com';document.getElementById('passwd').value='13557024091-zyx'";
        // 执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}
// MARK: - 设置代理
extension OAuthViewController:UIWebViewDelegate {
    // 开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    // 网页加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    // 网页加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    // 开始加载网页
    // ->true 继续加载网页 ->false 不再加载网页
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 获取加载网页的url
        guard let url = request.url else {
            return true
        }
        // 获取url对应的string
        let urlString = url.absoluteString
        // 判断该字符串是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        // 获取code
        let code = urlString.components(separatedBy: "code=").last!
        // 获取accessToken
        loadAccessToken(code: code)
        return false
    }
}
// MARK: - 获取accessToken
extension OAuthViewController {
    // 请求accessToken
    func loadAccessToken(code:String) {
        NetworingTools.shareInstance.loadOauthToken(code: code, finished: {(result:[String : AnyObject]?, error:NSError?) -> Void in
            // 错误校验
            if error != nil {
                print(error!)
                return
            }
            // 字典转模型数据
            let account:UserAccount = UserAccount.init(dict: result!)
            // 获取用户信息
            self.loadUserInfo(account: account)
        })
    }
    // 获取用户信息
    func loadUserInfo(account:UserAccount) {
        // 获取token
        guard let token = account.access_token else {
            return
        }
        // 获取uid
        guard let uid = account.uid else {
            return
        }
        NetworingTools.shareInstance.loadUserInfo(accessToken: token, uid: uid, finished: {(result, error) ->Void in
            // 错误校验
            if (error != nil) {
                return
            }
            // 拿到用户信息的结果
            guard let userDict = result else {
                return
            }
            // 获取用户头像和昵称
            account.avatar_hd = userDict["avatar_hd"] as? String
            account.screen_name = userDict["screen_name"] as? String
            // 获取沙盒路径
            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            accountPath = (accountPath as NSString).appendingPathComponent("account.plist")
            print(accountPath)
            // 保存用户信息
            NSKeyedArchiver.archiveRootObject(account, toFile: accountPath)
            // 将用户信息赋值给单例
            UserAccountViewModel.shareInstance.account = account;
            // 退出授权界面并且跳转欢迎界面
            self.dismiss(animated: false, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        })
    }
    
}






