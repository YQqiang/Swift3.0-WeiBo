//
//  ComposeViewController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/15.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    // MARK:- 懒加载属性
    fileprivate lazy var composeTitleView: ComposeTitleView = ComposeTitleView()
    fileprivate lazy var images:[UIImage] = [UIImage]()
    fileprivate lazy var emoticonVc : EmoticonController = EmoticonController {[weak self] (emoticon) -> () in
        self?.textView.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.textView)
    }
    
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
        //监听删除照片按钮的点击
        NotificationCenter.default.addObserver(self, selector: #selector(removePhotoClick(noti:)), name: NSNotification.Name(rawValue: PicPickerRemovePhotoNote), object: nil)
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
        //0.退出键盘
        textView.resignFirstResponder()
        //1.获取发送微博的正文
        let statusText = textView.getEmoticonString()
        //2.定义回调的闭包
        let finishedCallback = { (isSuccess: Bool) -> () in
            if !isSuccess {
                SVProgressHUD.showError(withStatus: "发送微博失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送微博成功")
            self.dismiss(animated: true, completion: nil)
        }
        //3.获取用户选中的图片
        if let image = images.first {
            NetWorkTools.shareInstance.sendStatus(statusText, image: image, isSuccess: finishedCallback)
        } else {
            NetWorkTools.shareInstance.sendStatus(statusText, isSuccess: finishedCallback)
        }
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
    @IBAction func emoticonBtnClick() {
        //1.退出键盘
        textView.resignFirstResponder()
        //2.切换键盘
        textView.inputView = textView.inputView != nil ? nil : emoticonVc.view
        //3.弹出键盘
        textView.becomeFirstResponder()
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
    @objc fileprivate func removePhotoClick(noti: Notification) {
        //1.获取image对象
        guard let image = noti.object as? UIImage else {
            return
        }
        //2.获取image对象所对应的下标值
        guard let index = images.index(of: image) else {
            return
        }
        //3.将图片从数组移除
        images.remove(at: index)
        //4.重新复制collectionView新的数组
        picPickerView.images = images
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
        picPickerView.images = images
        //4.退出选中照片控制器
        picker.dismiss(animated: true, completion: nil)
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

