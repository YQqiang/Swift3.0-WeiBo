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
    var created_at: String?      //微博创建时间
    var source: String?          //微博来源
    var text: String?            //微博正文
    var mid: Int = 0             //微博的ID
    
    // MARK:- 自定义构造函数
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
