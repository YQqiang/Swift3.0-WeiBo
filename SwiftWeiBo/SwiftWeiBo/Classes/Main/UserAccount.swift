//
//  UserAccount.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/10.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class UserAccount: NSObject {
    
    // MARK:- 属性
    //授权access_token
    var access_token: String?
    //过期时间
    var expires_in: TimeInterval = 0.0 {
        didSet {
            expires_date = NSDate(timeIntervalSinceNow: expires_in)
        }
    }
    //用户id
    var uid: String?
    // 过期日期
    var expires_date : NSDate?
    // 昵称
    var screen_name: String?
    //用户头像地址
    var avatar_large: String?
    
    // MARK:- 自定义构造函数
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    // MARK:- 重写description属性
    override var description: String {
        return dictionaryWithValues(forKeys: ["access_token", "expires_date", "uid", "screen_name", "avatar_large"]).description
    }
}
