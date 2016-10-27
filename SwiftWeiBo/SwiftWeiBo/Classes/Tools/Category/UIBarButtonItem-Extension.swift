//
//  UIBarButtonItem-Extension.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/27.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String) {
        let button = UIButton(imageName: imageName, bgImageName: "")
        button.sizeToFit()
        self.init(customView: button)
    }
}
