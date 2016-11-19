//
//  PhotoBrowserController.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/19.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit
import SVProgressHUD

private let PhotoBrowserCell = "PhotoBrowserCell"

class PhotoBrowserController: UIViewController {
    // MARK:- 自定义属性
    let indexPath: IndexPath
    let picUrls: [URL]
    
    // MARK:- 懒加载属性
    fileprivate lazy var collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: PhotoBrowserCollectionViewLayout())
    fileprivate lazy var closeBtn: UIButton = UIButton.init(bgColor: UIColor.darkGray, fontSize: 14, title: "关闭")
    fileprivate lazy var saveBtn: UIButton = UIButton.init(bgColor: UIColor.darkGray, fontSize: 14, title: "保存")
    
    // MARK:- 自定义构造函数
    init(indexPath: IndexPath, picUrls: [URL]) {
        self.indexPath = indexPath
        self.picUrls = picUrls
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        view.frame.size.width += 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //1.设置界面
        seupUI()
        //2.滚动到对应的图片
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

// MARK:- 设置界面
extension PhotoBrowserController {
    fileprivate func seupUI() {
        //1.添加控件
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        collectionView.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        //2.设置frame
        collectionView.frame = view.bounds
        closeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.bottom.equalTo(-20)
            make.size.equalTo(CGSize(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-40)
            make.bottom.equalTo(closeBtn.snp.bottom)
            make.size.equalTo(closeBtn.snp.size)
        }
        //3.设置collectionView的属性
        collectionView.register(PhotoBrowserViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCell)
        collectionView.dataSource = self
        //设置两个按钮的监听函数
        closeBtn.addTarget(self, action: #selector(closeBtnAciton), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
    }
}

// MARK:- 事件监听
extension PhotoBrowserController {
    @objc fileprivate func closeBtnAciton() {
        dismiss(animated: true, completion: nil)
    }
    @objc fileprivate func saveBtnAction() {
        //1.获取当前正在显示的image
        let cell = collectionView.visibleCells.first as! PhotoBrowserViewCell
        guard let image = cell.imageView.image else {
            return
        }
        //2.将image对象保存相册
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc fileprivate func image(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: Any) {
        var showInfo = ""
        if error != nil {
            showInfo = "保存失败"
        } else {
            showInfo = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: showInfo)
    }
}

// MARK:- UICollectionViewDataSource
extension PhotoBrowserController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCell, for: indexPath) as! PhotoBrowserViewCell
        cell.picUrl = picUrls[indexPath.item]
        cell.delegate = self
        return cell
    }
}

extension PhotoBrowserController: PhotoBrowserViewCellDelegate {
    func imageClick() {
        closeBtnAciton()
    }
}

class PhotoBrowserCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        //1.设置itemSize
        itemSize = (collectionView?.frame.size)!
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        //2.设置collectionView的属性
        collectionView?.isPagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}


