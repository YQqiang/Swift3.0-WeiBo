//
//  StatusViewModel.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/14.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class StatusViewModel: NSObject {
    // MARK:- 定义属性
    var status: Status?
    
    // MARK:- 对数据处理的属性
    /**
     处理来源
     */
    var sourceText: String?
    /**
     处理创建时间
     */
    var createAtText: String?
    /**
     处理用户认证图标
     */
    var verifiedImage: UIImage?
    /**
     处理用户会员等级
     */
    var vipImage: UIImage?
    /**
     用户头像的处理
     */
    var profileURL: URL?
    
    // MARK:- 自定义构造函数
    init(status: Status) {
        super.init()
        self.status = status
        if let source = status.source, source != "" {
            //2.对来源的字符串进行处理
            let startIndex = (source as NSString).range(of: ">").location + 1
            let lenth = (source as NSString).range(of: "</").location - startIndex
            //3.截取字符串
            sourceText = (source as NSString).substring(with: NSMakeRange(startIndex, lenth))
        }
        
        if let createAt = status.created_at {
            //2.对时间处理
            createAtText = NSDate.createDateString(createAtStr: createAt)
        }
        //3.处理认证图标
        let verifiedType = status.user?.verified_type ?? -1
        switch verifiedType {
        case 0:
            verifiedImage = #imageLiteral(resourceName: "avatar_vip")
        case 2,3,5:
            verifiedImage = #imageLiteral(resourceName: "avatar_enterprise_vip")
        case 220:
            verifiedImage = #imageLiteral(resourceName: "avatar_grassroot")
        default:
            verifiedImage = nil
        
        }
        //4.处理会员等级
        let mbrank = status.user?.mbrank ?? -1
        if mbrank > 0 && mbrank <= 6 {
            vipImage = UIImage(named: "common_icon_membership_level\(mbrank)")
        }
        //5.用户头像的处理
        let profileURLString = status.user?.profile_image_url ?? ""
        profileURL = URL(string: profileURLString)
    }
}








