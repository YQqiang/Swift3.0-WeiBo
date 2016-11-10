//
//  UserAccountModel.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/10.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import Foundation

class UserAccountModel {
    // MARK:- 将类设计成单利
    static let shareIntance: UserAccountModel = UserAccountModel()
    // MARK:- 定义属性
    var account: UserAccount?
    
    // MARK:- 设计属性
    var accountPath: String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return (accountPath as NSString).appendingPathComponent("accout.plist")
    }
    var isLogin: Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else {
            return false
        }
        return expiresDate.compare(NSDate() as Date) == ComparisonResult.orderedDescending
    }
    
    // MARK:- 重写init函数
    init() {
        //1.从沙盒中读取归档信息
        account = NSKeyedUnarchiver.unarchiveObject(withFile: accountPath) as! UserAccount?
    }
}
