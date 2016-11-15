//
//  Status.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/12.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class Status: NSObject {
    // MARK:- 属性
    /**
     微博创建时间
     */
    var created_at: String?
    /**
     微博来源
     */
    var source: String?
    /**
     微博正文
     */
    var text: String?
    /**
     微博的ID
     */
    var mid: Int = 0
    /**
     微博的配图
     */
    var pic_urls: [[String: String]]?
    /**
     转发的微博
     */
    var retweeted_status: Status?
    var user: User?
    
    // MARK:- 对数据处理的属性
    
    // MARK:- 自定义构造函数
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dic)
        //1.将用户字典转为用户模型对象
        if let userDic = dic["user"] as? [String : AnyObject] {
            user = User(dic: userDic)
        }
        //2.将转发微博字典转换为转发微博模型对象
        if let retweetedStatusDict = dic["retweeted_status"] as? [String: AnyObject] {
            retweeted_status = Status(dic: retweetedStatusDict)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
