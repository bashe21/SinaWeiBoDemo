//
//  NetworingTools.swift
//  AFNetworkingProject
//
//  Created by 张哈哈 on 2016/12/26.
//  Copyright © 2016年 Mr Zhang. All rights reserved.
//

import AFNetworking
enum RequestType:String {
    case get = "GET"
    case post = "POST"
}
// 通过shareInstance
class NetworingTools: AFHTTPSessionManager {
    static let shareInstance:NetworingTools = {
        let tools = NetworingTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}
// MARK: - 封装数据请求方法
extension NetworingTools {
    func request(networkingType:RequestType,urlString:String,parameters:[String:AnyObject],finished:@escaping (_ result:AnyObject?,_ error:Error?)->()) {
        // 1、定义成功的闭包
        let successCallBack = {(task:URLSessionDataTask, result:Any?) -> Void in
            finished(result as AnyObject?, nil)
        }
        // 2、定义失败的闭包
        let failureCallBack = {(tast:URLSessionDataTask?, error:Error) -> Void in
            finished(nil, error)
        }
        // 3、发送网络请求
        if networkingType == .get {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        else {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}

// MARK: - 获取accessToken
extension NetworingTools {
    func loadOauthToken(code:String,finished:@escaping (_ resutlt:[String:AnyObject]?,_ error:NSError?)->()) {
        // 获取请求的url
        let urlString = "https://api.weibo.com/oauth2/access_token"
        // 获取请求的参数
        let parameters = ["client_id":App_Key,"client_secret":App_Secret,"grant_type":"authorization_code","code":code,"redirect_uri":redirect_uri]
        // 请求数据
        NetworingTools.shareInstance.request(networkingType: .post, urlString: urlString, parameters: parameters as [String : AnyObject], finished: {(result:AnyObject?, error:Error?) -> Void in
            finished(result as? [String:AnyObject], error as NSError?)
        })
    }
}
// MARK: - 获取用户信息
extension NetworingTools {
    func loadUserInfo(accessToken:String,uid:String,finished:@escaping (_ result:[String:AnyObject]?,_ error:NSError?)->()) {
        // 获取请求的url
        let urlString = "https://api.weibo.com/2/users/show.json"
        // 获取请求的参数
        let parameters = ["access_token":accessToken,"uid":uid]
        // 发送请求
        NetworingTools.shareInstance.request(networkingType: .get, urlString: urlString, parameters: parameters as [String : AnyObject], finished: {(result, error) ->Void in
            finished(result as? [String:AnyObject],error as? NSError)
        })
    }
}

extension NetworingTools {
    func loadStatuses(since_id:Int,max_id:Int,finish:@escaping (_ result:[[String:AnyObject]]?,_ error:NSError?)->())  {
        // 获取请求urlString
        let urlSstring = "https://api.weibo.com/2/statuses/home_timeline.json"
        // 获取请求参数
        let parameters = ["access_token":(UserAccountViewModel.shareInstance.account?.access_token ?? ""),"since_id":"\(since_id)","max_id":"\(max_id)"]
        // 获取请求数据
        NetworingTools.shareInstance.request(networkingType: .get, urlString: urlSstring, parameters: parameters as [String : AnyObject]) { (result, error) in
            // 错误数据校验
            if error != nil {
                print(finish(nil,error as? NSError))
                return
            }
            // 将数组数据传递给外界控制器
            finish((result?["statuses"]) as? [[String:AnyObject]], nil)
        }
    }
}
// MARK: - 发送微博
extension NetworingTools {
    func sendMessage(statusText:String,isSuccess:@escaping (_ isSuccess:Bool)->()) {
        // 获取请求地址
        let urlString = "https://api.weibo.com/2/statuses/update.json"
        // 获取请求参数
        let parameters = ["access_token":UserAccountViewModel.shareInstance.account?.access_token,"status":statusText]
        // 发送请求
        request(networkingType: .post, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) in
            if error == nil {
                isSuccess(true)
            }
            else {
                isSuccess(false)
            }
        }
    }
}
// MARK: - 发送带图片的微博
extension NetworingTools {
    func sendMessage(statusText:String,image:UIImage,isSuccess:@escaping (_ isSuccess:Bool)->()) {
        // 获取请求地址
        let urlString = "https://api.weibo.com/2/statuses/upload.json"
        // 获取请求参数
        let parameters = ["access_token":UserAccountViewModel.shareInstance.account?.access_token,"status":statusText]
        post(urlString, parameters: parameters, constructingBodyWith: { (formatData) in
            if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                formatData.appendPart(withFileData: imageData, name: "pic", fileName: "zyx", mimeType: "jpeg")
            }
        }, progress: nil, success: { (_, _) in
            isSuccess(true)
        }) { (_, error) in
            isSuccess(false)
        }
    }
}




