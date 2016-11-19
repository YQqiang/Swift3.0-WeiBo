//
//  HomeViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/10/25.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    // MARK:- 属性
    var isPresented = false
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleButton: TitleButton = TitleButton()
    //注意: 在闭包中如果使用当前对象的属性或者调用方法,也需要加self
    //两个地方需要使用self: 1> 如果在一个函数中出现歧义; 2> 在闭包中使用当前对象的属性或者调用方法.
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator {[weak self] (presented) -> () in
        self!.titleButton.isSelected = presented
    }
    fileprivate lazy var viewModels: [StatusViewModel] = [StatusViewModel]()
    fileprivate lazy var tipLabel: UILabel = UILabel()
    fileprivate lazy var photoBrowserAnimator: PhotoBrowserAnimator = PhotoBrowserAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.没有登录时设置的内容
        visistorView.addRotationAnim()
        if !isLogin {
            return
        }
        //2.设置导航栏内容
        setupNavigationBar()
        //3.自动计算cell高度
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        //4.布局header
        setupHeader()
        setupFooter()
        //5.设置提示的Label
        setupTipLabel()
        //6.监听通知
        setupNotiications()
    }
}

// MARK:- 设置UI界面
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        //设置标题
        titleButton.setTitle("逆行云", for: .normal)
        titleButton.addTarget(self, action: #selector(HomeViewController.clickTitleBtn(_:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
    fileprivate func setupHeader() {
        //1.创建headerView
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewStatuses))
        //2.设置header的属性
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for: .refreshing)
        //3.设置tableView的header
        tableView.mj_header = header
        //4.进入刷新状态
        tableView.mj_header.beginRefreshing()
    }
    fileprivate func setupFooter() {
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }
    fileprivate func setupTipLabel() {
        //1.将tipLabel放到父控件中
        navigationController?.navigationBar.insertSubview(tipLabel, at: 0)
        //2.设置tipLabel的frame
        tipLabel.frame = CGRect(x: 0, y: 10, width: UIScreen.main.bounds.width, height: 32)
        //3.设置tipLabel的属性
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.layer.cornerRadius = 10
        tipLabel.layer.masksToBounds = true
        self.tipLabel.alpha = 0
        tipLabel.isHidden = true
    }
    fileprivate func setupNotiications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser), name: Notification.Name(ShowPhotoBrowserNote), object: nil);
    }
    @objc fileprivate func showPhotoBrowser(noti: Notification) {
        //1.取出通知的信息
        let indexPath = noti.userInfo?[ShowPhotoBrowserIndexKey]
        let picUrls = noti.userInfo?[ShowPhotoBrowserUrlsKey]
        //2.弹出照片浏览器
        let photoBrowserVc = PhotoBrowserController.init(indexPath: indexPath as! IndexPath, picUrls: picUrls as! [URL])
        photoBrowserVc.modalPresentationStyle = .custom
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        present(photoBrowserVc, animated: true, completion: nil)
    }
}

//MARK:- 事件监听
extension HomeViewController {
    @objc fileprivate func clickTitleBtn(_ sender: TitleButton) {
        //1.改变按钮状态
        sender.isSelected = !sender.isSelected
        //2.创建弹出的控制器
        let popoverVC = PopViewController()
        //3.设置控制器的modal样式
        popoverVC.modalPresentationStyle = .custom
        //设置转场的代理
        popoverVC.transitioningDelegate = popoverAnimator
        //4.弹出控制器
        present(popoverVC, animated: true) { 
            
        }
    }
}

// MARK:- 请求数据
extension HomeViewController {
    @objc fileprivate func loadNewStatuses() {
        loadStatuses(isNewData: true)
    }
    @objc fileprivate func loadMoreStatuses() {
        loadStatuses(isNewData: false)
    }
    
    fileprivate func loadStatuses(isNewData: Bool) {
        //获取sinceId/max_id
        var since_id = 0
        var max_id = 0
        if isNewData {
            since_id = viewModels.first?.status?.mid ?? 0
        } else {
            max_id = viewModels.last?.status?.mid ?? 0
            max_id = max_id == 0 ? 0 : max_id - 1
        }
        
        NetWorkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (result, error) in
            //1.校验错误
            if error != nil {
                print(error!)
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                return
            }
            //2.获取可选类型中的数据
            guard let resultArray = result else {
                return
            }
            //3.遍历微博对应的字典
            var tempViewModels = [StatusViewModel]()
            for statusDic in resultArray {
                let status = Status(dic: statusDic)
                let viewModel = StatusViewModel(status: status)
                tempViewModels.append(viewModel)
//                print(statusDic)
            }
            //4.将数据放入到成员变量的数组中
            if isNewData {
                self.viewModels = tempViewModels + self.viewModels
            } else {
                self.viewModels += tempViewModels
            }
            //4.缓存图片
            self.cacheImages(viewModels: tempViewModels)
        }
    }
}

// MARK:- 缓存图片
extension HomeViewController {
    fileprivate func cacheImages(viewModels: [StatusViewModel]) {
        //0. 创建group
        let group = DispatchGroup()
        //1. 缓存图片
        for viewModel in viewModels {
            for picUrl in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared().downloadImage(with: picUrl, options: [], progress: nil, completed: { (_, _, _, _, _) -> Void in
                    print("下载了一张图片")
                    group.leave()
                })
            }
        }
        //2.刷新表格
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            //显示提示的Label
            self.showTipLabel(count: viewModels.count)
        }
    }
    private func showTipLabel(count: Int) {
        //1.设置tipLabel的属性
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "没有新微薄" : "\(count)条新微薄"
        UIView.animate(withDuration: 0.25, animations: {
            () -> Void in
            self.tipLabel.frame.origin.y = 44
            self.tipLabel.alpha = 1.0
        }) { (_) -> Void in
            UIView.animate(withDuration: 0.25, delay: 1.0, options: [], animations: { () -> Void in
                self.tipLabel.frame.origin.y = 10
                self.tipLabel.alpha = 0
            }, completion: { (_) -> Void in
                self.tipLabel.isHidden = true
            })
        }
    }
}

// MARK:- tableView 的数据源方法
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1.创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! HomeViewCell
        //2.给cell设置数据
        let viewModel = viewModels[indexPath.row]
        cell.viewModel = viewModel
        return cell
    }
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let viewModel = viewModels[indexPath.row]
//        return viewModel.cellHeight
//    }
}




