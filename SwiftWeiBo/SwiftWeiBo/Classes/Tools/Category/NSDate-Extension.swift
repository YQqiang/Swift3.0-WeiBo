//
//  NSDate-Extension.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/12.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

extension NSDate {
    class func createDateString(createAtStr: String) -> String {
        //1.创建时间格式化对象
        let fmt = DateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = Locale(identifier: "en")
        //2.将字符串时间转为date类型
        guard let createDate = fmt.date(from: createAtStr) else {
            return ""
        }
        //3.创建当前时间
        let nowDate = Date()
        //4.计算创建时间和当前时间的差值
        let interval = Int(nowDate.timeIntervalSince(createDate))
        //5.对时间间隔处理
        //5.1显示刚刚
        if interval < 60 {
            return "刚刚"
        }
        //5.2 59分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        //5.3 11小时前
        if interval < 60 * 60 * 12 {
            return "\(interval / 60 / 60)小时前"
        }
        //5.4 创建日历对象
        let calendar = Calendar.current
        //5.5 处理昨天数据 昨天 12:33
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        //5.6 处理一年之内: 02-22 18:56
        let cmps = calendar.dateComponents([.year], from: createDate, to: nowDate)
        if cmps.year! < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.string(from: createDate)
            return timeStr
        }
        //5.7 超过一年 2014-03-45 HH:mm
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.string(from: createDate)
        return timeStr
    }
}
