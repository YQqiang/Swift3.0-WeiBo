//
//  OAuthViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/10.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置导航栏内容
        setupNavitationBar()
        //2.加载网页
        loadPage()
    }

}

// MARK:- 设置UI界面相关
extension OAuthViewController {
    fileprivate func setupNavitationBar() {
        //1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(OAuthViewController.closeItemClick))
        //2.设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .plain, target: self, action: #selector(fillItemClick))
        //3.设置标题
        navigationItem.title = "登录页面"
    }
    
    fileprivate func loadPage() {
        //1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        //2.创建对应的URL
        guard let url = URL(string: urlString) else {
            return
        }
        //3.创建NSURLRequest对象
        let urlRequest = URLRequest(url: url)
        //4.加载Request对象
        webView.loadRequest(urlRequest)
    }
}

// MARK:- 事件监听函数
extension OAuthViewController {
    @objc fileprivate func closeItemClick() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func fillItemClick() {
        //1.书写js代码   JavaScript / Java   ---->   雷锋 / 雷峰塔
        let jsCode = "document.getElementById('userId').value='1054572107@qq.com';document.getElementById('passwd').value='yuqiang...';"
        //2.执行js代码
        webView.stringByEvaluatingJavaScript(from: jsCode)
    }
}

// MARK:- webView的代理方法
extension OAuthViewController : UIWebViewDelegate {
    //1.开始加载网页
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    //2.加载网页失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
    //.3.加载网页完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    /// 4.当准备加载某一个页面时,会执行这个方法
    ///
    /// - Parameters:
    ///   - webView: webView
    ///   - request: request
    ///   - navigationType: navigation
    /// - Returns: true-->继续加载    false-->不加载
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //1.获取加载网页的URL
        guard let url = request.url else {
            return true
        }
        //2.获取URL中的字符串
        let urlString = url.absoluteString
        //3.判断该字符串是否包含code
        guard urlString.contains("code=") else {
            return true
        }
        //4.将code取出来
        let code = urlString.components(separatedBy: "code=").last!
        //5.请求accessToken
        loadAccessToken(code: code)
        return false
    }
}

// MARK:- 请求数据
extension OAuthViewController {
    fileprivate func loadAccessToken(code: String) {
        NetWorkTools.shareInstance.loadAccessToken(code) {
            (result, error) -> () in
            // 1.错误校验
            if error != nil {
                print(error!)
                return
        }
            // 2.拿到结果
            guard let accountDic = result else {
                print("没有获取授权后的数据")
                return
            }
            //3.将字典转成模型对象
            let account = UserAccount(dic: accountDic as [String : AnyObject])
            //4.请求用户信息
            self.loadUserInfo(account: account)
        }
    }
    
    fileprivate func loadUserInfo(account: UserAccount) {
        //1.获取acces_token
        guard let accessToken = account.access_token else {
            return
        }
        //2.获取uid
        guard let uid = account.uid else {
            return
        }
        //3.发送网络请求
        NetWorkTools.shareInstance.loadUserInfo(access_token: accessToken, uid: uid) {
            (result, error) -> () in
            //错误校验
            if error != nil {
                print(error!)
                return
            }
            //拿到用户结果
            guard let userInfo = result else {
                return
            }
            //从字典中取出用户头像地址和昵称
            account.screen_name = userInfo["screen_name"] as! String?
            account.avatar_large = userInfo["avatar_large"] as! String?
            print(account)
            //4.将account对象保存
            //4.1获取沙盒路径
//            var accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            accountPath = (accountPath as NSString).appendingPathComponent("accout.plist")
//            print(accountPath)
            //4.2保存对象
            NSKeyedArchiver.archiveRootObject(account, toFile: UserAccountModel.shareIntance.accountPath)
            //5.将account对象设置到单利对象中
            UserAccountModel.shareIntance.account = account
            //6.退出当前控制器
            self.dismiss(animated: true, completion: {
                UIApplication.shared.keyWindow?.rootViewController = WelcomeViewController()
            })
        }
    }
}



