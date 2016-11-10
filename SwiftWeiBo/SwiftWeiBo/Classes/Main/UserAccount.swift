//
//  UserAccount.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/10.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class UserAccount: NSObject, NSCoding {
    
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
    
    // MARK:- 归档&&解档
    /**
     如果子类需要添加异于父类的初始化方法时，必须先要实现父类中使用required修饰符修饰过的初始化方法，并且也要使用required修饰符而不是override。
     如果子类中不需要添加任何初始化方法，我们则可以忽略父类的required初始化方法
     */
    //解档的方法
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        uid = aDecoder.decodeObject(forKey: "uid") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? NSDate
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        screen_name = aDecoder.decodeObject(forKey: "screen_name") as? String
    }
    //归档的方法
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(screen_name, forKey: "screen_name")
        aCoder.encode(avatar_large, forKey: "avatar_large")
    }
}
