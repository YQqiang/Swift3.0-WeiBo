//
//  MainViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/25.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    
    // MARK:- 懒加载属性
    fileprivate lazy var composeBtn: UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    private lazy var imageNames = ["tabbar_home", "tabbar_message_center", "", "tabbar_discover", "tabbar_profile"]
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        //1.遍历所有的item
        for i in 0 ..< tabBar.items!.count {
            //2.获取item
            let item = tabBar.items![i]
            //3.如果下标为2,则不可以和用户交互
            if i == 2 {
                item.isEnabled = false
                
            }
            //4.设置高亮图片
            item.selectedImage = UIImage.init(named: imageNames[i] + "_highlighted")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComposeBtn()
/*
        //1.获取文件json路径
        /*
         guard
            1.是对你所期望的条件做检查,而并非不符合你期望的.右和assert很相似.如果条件不符合,guard和else语句就运行,从而退出这个函数.
            2.如果通过了条件判断,可选类型的变量在guard语句被调用的范围内会被自动的拆包
            3.对你所不期望的情况早做检查,使得你写的函数更易读,更易维护.
         */
        guard let jsonPath = Bundle.main.path(forResource: "MainVCSettings.json", ofType: nil) else {
            print("没有找到路径")
            return
        }
        
        //2.读取json中的文件
        guard let jsonData = try?Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            print("没有获取到json文件中的数据")
            return
        }
        
        //3.data转成数组
        /*
         如果在调用系统某个方式时,该方法最后有一个throws,说明该方法会抛出异常.
         如果一个方法会抛出异常,那么需要对该异常进行处理.
         在Swift中有三种处理异常的方式.
         
         */
        /*
        //方式一: try方式,程序员手动捕捉异常
        do {
            try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        } catch  {
            //error 错误
        }
        //方式二: try?方式(常用方式),系统帮助我们处理异常,如果该方法出现异常,则该方法返回nil,如果没有异常,则返回对应的对象.
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return
        }
        //方式三: try!方法(不建议,非常危险),直接告诉系统该方法没有异常.如果该方法出现了异常,那么程序会崩溃.
        let anyObject1 = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        */
 
        guard let anyObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
            return
        }
        guard let dictArr = anyObject as? [[String: AnyObject]] else {
            return
        }
        
        //4.遍历字典,获取对应的信息.
        for dict in dictArr {
            //4.1获取控制器对应的字符串.
            guard let VCName = dict["vcName"] as? String else {
                continue
            }
            //4.2获取控制器显示的title
            guard let title = dict["title"] as? String else {
                continue
            }
            //4.3获取控制器显示的图标名称
            guard let imageName = dict["imageName"] as? String else {
                continue
            }
            //4.4添加子控制器
            addChildViewController(VCName, title: title, imageName: imageName)
        }
        
        
        // Do any additional setup after loading the view.
//        addChildControllerWithNav(chiledVC: HomeViewController(), title: "首页", imageName: "tabbar_home")
//        addChildControllerWithNav(chiledVC: MessageViewController(), title: "消息", imageName: "tabbar_message_center")
//        addChildControllerWithNav(chiledVC: DiscoverViewController(), title: "发现", imageName: "tabbar_discover")
//        addChildControllerWithNav(chiledVC: ProfileViewController(), title: "我", imageName: "tabbar_profile")
 */
    }
    
    fileprivate func addChildViewController(_ childVCName: String, title: String, imageName: String) {
        //0,获取命名空间
        guard let nameSapce = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            print("没有获取到命名空间")
            return
        }
        //1,根据字符串获取对应的Class
        guard let childVCClass = NSClassFromString(nameSapce + "." + childVCName)   else {
            print("没有获取到字符串对应的Class")
            return
        }
        //2,将对应的anyObject转换成控制器类型
        guard let childVCType = childVCClass as? UIViewController.Type else {
            print("没有获取到对应的控制器类型")
            return
        }
        //3,创建对应的控制器对象.
        let chiledVC = childVCType.init()
        //4.设置自控制器属性
        chiledVC.title = title
        chiledVC.tabBarItem.image = UIImage(named: imageName)
        chiledVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        //5.包装导航控制器
        let nav = UINavigationController.init(rootViewController: chiledVC)
        //6.添加自控制器
        addChildViewController(nav)
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

//MARK:- 设置UI界面
extension MainViewController {
    //设置发布按钮
    fileprivate func setupComposeBtn() {
        //1.将composeBtn添加到tabBar上
        tabBar.addSubview(composeBtn)
        //2.设置属性
//        composeBtn.setBackgroundImage(UIImage.init(named: "tabbar_compose_button"), for: UIControlState.normal)
//        composeBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), for: UIControlState.highlighted)
//        composeBtn.setImage(UIImage.init(named: "tabbar_compose_icon_add"), for: UIControlState.normal)
//        composeBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), for: UIControlState.highlighted)
//        composeBtn.sizeToFit()
        //3.设置位置
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height * 0.5)
        //4.监听发布按钮的点击
        composeBtn.addTarget(self, action: #selector(MainViewController.clickcomposeBtn), for: .touchUpInside)
    }
}

// MARK:- 事件监听
extension MainViewController {
    //事件监听的本质是发消息,但是发送消息是OC的特性.
    //将方法包装成@SEL ----> 类中查找方法列表 ----> 根据@SEL找到imp指针(函数指针) ---> 执行函数.
    //如果Swift中将一个函数声明为private, 那么该函数不会被添加到方法列表中
    //如果在private 前加上 @objc ,那么该方法依然会被添加到方法列表中
    @objc fileprivate func clickcomposeBtn() {
        print("点击了发布按钮")
    }
}




