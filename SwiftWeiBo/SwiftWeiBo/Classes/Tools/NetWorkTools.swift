//
//  NetWorkTools.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/10.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import AFNetworking

// 定义枚举类型
enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
}

class NetWorkTools: AFHTTPSessionManager {
    //let 是线程安全的
    static let shareInstance: NetWorkTools = {
        let tools = NetWorkTools()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
}

// MARK:- 封装请求方法
extension NetWorkTools {
    func request(_ methodType : RequestType, urlString : String, parameters : [String : AnyObject], finished : @escaping (_ result : Any?, _ error : Error?) -> ()) {
        
        // 1.定义成功的回调闭包
        let successCallBack = { (task : URLSessionDataTask, result : Any?) -> Void in
            finished(result, nil)
        }
        
        // 2.定义失败的回调闭包
        let failureCallBack = { (task : URLSessionDataTask?, error : Error) -> Void in
            finished(nil, error)
        }
        
        // 3.发送网络请求
        if methodType == .GET {
            get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        } else {
            post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
        
    }
}

// MARK:- 请求accessToken
extension NetWorkTools {
    func loadAccessToken(_ code: String, finished: @escaping (_ result : [String : Any]?, _ error : Error?) -> ()) {
        //1.获取请求的URLstring
        let urlString = "https://api.weibo.com/oauth2/access_token"
        //2.获取请求的参数
        let parameters = ["client_id" : app_key, "client_secret" : app_secret, "grant_type" : "authorization_code", "redirect_uri" : redirect_uri, "code" : code]
        //3.发送网络请求
        request(.POST, urlString: urlString, parameters: parameters as [String : AnyObject]) { (result, error) -> () in
            finished(result as? [String : AnyObject], error)
        }
    }
}

// MARK:- 请求用户信息
extension NetWorkTools {
    func loadUserInfo(access_token: String, uid: String, finished: @escaping (_ result : [String : Any]?, _ error : Error?) -> ()) -> () {
        //1.获取请求的URLString
        let urlString = "https://api.weibo.com/2/users/show.json"
        //2.获取请求的参数
        let parameters = ["access_token": access_token, "uid": uid]
        //3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters as [String : AnyObject]) {
            (result, error) -> () in
            finished(result as? [String : AnyObject], error)
        }
    }
}

// MARK:- 请求首页数据
extension NetWorkTools {
    func loadStatuses(since_id: Int, max_id: Int, finished: @escaping (_ result: [[String: AnyObject]]?, _ error: Error?) -> ()) -> () {
        //1.获取请求的URLstring
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        //2.获取请求的参数
        let parameters = ["access_token": UserAccountModel.shareIntance.account?.access_token!, "since_id": "\(since_id)", "max_id": "\(max_id)"]
        //3.发送网络请求
        request(.GET, urlString: urlString, parameters: parameters as [String : AnyObject]) {
            (result, error) -> () in
            //1.获取字典的数据
            guard let resultDic = result as? [String: AnyObject] else {
                finished(nil, error)
                return
            }
            //2.将数组数据回调给外界控制器
            finished(resultDic["statuses"] as? [[String : AnyObject]], error)
        }
    }
}

