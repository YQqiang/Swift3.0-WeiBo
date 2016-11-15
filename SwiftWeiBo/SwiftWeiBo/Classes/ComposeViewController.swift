//
//  ComposeViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/15.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    // MARK:- 懒加载属性
    fileprivate lazy var composeTitleView: ComposeTitleView = ComposeTitleView()
    fileprivate lazy var images:[UIImage] = [UIImage]()
    
    // MARK:- 控件属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerView: PicPickerCollectionView!
    
    // MARK:- 约束属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPicerViewHCons: NSLayoutConstraint!
    
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        //监听通知
        setupNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    //析构函数
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
}

// MARK:- 设置UI界面
extension ComposeViewController {
    fileprivate func setupNavigationBar() {
        //1.左侧关闭按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(closeItemClick))
        //2.右侧发布按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发布", style: .plain, target: self, action: #selector(sendItemClick))
        //3.设置标题
        composeTitleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = composeTitleView
    }
    
    fileprivate func setupNotifications() {
        //监听键盘的通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        //监听照片按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(addPhotoClick), name: Notification.Name.init(PicPickerAddPhotoNote), object: nil)
    }
}

// MARK:- 事件监听
extension ComposeViewController {
    @objc fileprivate func closeItemClick() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func sendItemClick() {
        print("sendItemClick")
    }
    @objc fileprivate func keyboardWillChangeFrame(noti: Notification) {
        //1.获取动画执行的时间
        let duration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        //2.获取键盘最终Y值
        let endFrame = (noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = endFrame.origin.y
        //3.计算工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - y
        //4.执行动画
        toolBarBottomCons.constant = margin
        UIView.animate(withDuration: duration, animations: {
            () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    @IBAction func picPickerBtnClick() {
        //1.退出键盘
        textView.resignFirstResponder()
        //2.执行动画
        picPicerViewHCons.constant = UIScreen.main.bounds.height * 0.65
        UIView.animate(withDuration: 0.25, animations: {
            () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

// MARK:- 添加照片和删除照片的事件
extension ComposeViewController {
    @objc fileprivate func addPhotoClick() {
        //1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            return
        }
        //2.创建照片选择控制器
        let ipc = UIImagePickerController()
        //3.设置照片源
        ipc.sourceType = .photoLibrary
        //4.设置代理
        ipc.delegate = self
        //5.弹出选择照片的控制器
        present(ipc, animated: true, completion: nil)
    }
}

// MARK:- UIImagePickerController的代理方法
extension ComposeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //1.获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        //2.将选中的照片添加到数组中
        images.append(image)
        //3.将数组赋值给collectionView, 让collectionView自己去展示数据
        
    }
}

// MARK:- textView的代理方法
extension ComposeViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderLabel.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        view.endEditing(true)
        textView.resignFirstResponder()
    }
}

