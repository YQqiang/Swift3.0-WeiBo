//
//  MainViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/25.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addChildControllerWithNav(chiledVC: HomeViewController(), title: "首页", imageName: "tabbar_home")
        addChildControllerWithNav(chiledVC: MessageViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildControllerWithNav(chiledVC: DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
        addChildControllerWithNav(chiledVC: ProfileViewController(), title: "我", imageName: "tabbar_profile")
    }
    
    //Swift支持方法重载
    //方法重载:方法名相同,参数不同-->1.参数的类型不同 2.参数的个数不同
    //private 在当前文件可以访问, 其他文件不能访问
    private func addChildControllerWithNav(chiledVC: UIViewController, title: String, imageName: String) {
        //1.设置自控制器的属性
        chiledVC.title = NSLocalizedString(title, comment: "")
        chiledVC.tabBarItem.image = UIImage.init(named: imageName)
        chiledVC.tabBarItem.selectedImage = UIImage.init(named: imageName + "_highlighted")
        //2.包装一个导航控制器
        let nav = UINavigationController(rootViewController: chiledVC)
        //3.添加自控制器
        addChildViewController(nav)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
