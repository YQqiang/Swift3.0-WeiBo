//
//  User.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/12.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class User: NSObject {
    // MARK:- 属性
    /**
     用户的头像
     */
    var profile_image_url: String?
    /**
     用户的昵称
     */
    var screen_name: String?
    /**
     用户的认证类型
     */
    var verified_type: Int = -1
    /**
     用户的会员等级
     */
    var mbrank: Int = 0
    
    // MARK:- 对用户数据处理
    
    // MARK:- 自定义构造函数
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
