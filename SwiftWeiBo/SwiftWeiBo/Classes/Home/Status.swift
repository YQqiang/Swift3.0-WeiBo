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
    var created_at: String? {
        didSet {
            //1. nil值校验
            guard let created_at = created_at else {
                return
            }
            //2.对时间处理
            createAtText = NSDate.createDateString(createAtStr: created_at)
        }
    }
    /**
     微博来源
     */
    var source: String? {
        didSet {
            //1.nil 值校验
            guard let source = source, source != "" else {
                return
            }
            //2.对来源的字符串进行处理
            let startIndex = (source as NSString).range(of: ">").location + 1
            let lenth = (source as NSString).range(of: "</").location - startIndex
            //3.截取字符串
            sourceText = (source as NSString).substring(with: NSMakeRange(startIndex, lenth))
            
        }
    }
    /**
     微博正文
     */
    var text: String?
    /**
     微博的ID
     */
    var mid: Int = 0
    var user: User?
    
    
    // MARK:- 对数据处理的属性
    var sourceText: String?
    var createAtText: String?
    
    // MARK:- 自定义构造函数
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeys(dic)
        //1.将用户字典转为用户模型对象
        if let userDic = dic["user"] as? [String : AnyObject] {
            user = User(dic: userDic)
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
    }
}
