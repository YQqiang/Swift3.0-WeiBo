//
//  HomeViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/25.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //mark: 懒加载
    lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.backgroundColor = UIColor.init(colorLiteralRed: Float(arc4random()%255)/255.0, green: Float(arc4random()%254)/255.0, blue: Float(arc4random()%255)/255.0, alpha: 1.0)
//        printLog(messsage: 123)
//    }
    
    func printLog<T>(messsage : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
        
        #if DEBUG
            
            let fileName = (file as NSString).lastPathComponent
            
            print("\(fileName):(\(lineNum))-\(messsage)")
            
        #endif
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

//mark: 延展
extension HomeViewController {
    func setupUI() -> Void {
        //1.将tableView加到控制器的View
        view.addSubview(tableView)
        //2.设置tableview的frame
        tableView.frame = view.bounds
        //3.设置数据源和代理
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//mark: tableView的数据源和代理
//extension 和 OC中cartegory类似,也是只能扩充方法,不能扩充属性
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 5
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.创建cell
        let cellID = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellID)
        }
        //2.给cell数据
        cell?.textLabel?.text = "第\(indexPath.section)组,第\(indexPath.row)行"
        //3.返回cell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printLog(messsage: "点击了第\(indexPath.row)行")
    }
}





