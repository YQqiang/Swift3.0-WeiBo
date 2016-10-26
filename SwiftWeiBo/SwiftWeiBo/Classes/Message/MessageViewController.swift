//
//  MessageViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/25.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    lazy var redView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let redView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        redView.center = view.center
        redView.backgroundColor = UIColor.red
        view.addSubview(redView)
        redView.layer.cornerRadius = 5.0
        redView.layer.borderColor = UIColor.cyan.cgColor
        redView.layer.borderWidth = 2.0
        
        let x = 20.0
        let margin = 20.0
        let count = 4.0
        let buttonW = (Double(view.frame.size.width) - 2.0 * x - (count - 1.0) * margin) / count
        let titles = ["平移", "放大", "缩小", "旋转"]
        for i in 0 ..< Int(count) {
            let button = UIButton.init(frame: CGRect.init(x: x + ((margin + buttonW) * Double(i)), y: 64.0, width: buttonW, height: 44.0))
            button.backgroundColor = UIColor.blue
            button.setTitle(titles[i], for: UIControlState.normal)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(clickButton(sender:)), for: UIControlEvents.touchUpInside)
            view.addSubview(button)
        }
    }
    
    func clickButton(sender: UIButton) -> Void {
//        switch sender.tag - 1000 {
//        case 0:
//            redView.transform = cga
//        case 1:
//            
//        case 2:
//            
//        case 3:
//            
//        default:
//            print("other")
//        }
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
