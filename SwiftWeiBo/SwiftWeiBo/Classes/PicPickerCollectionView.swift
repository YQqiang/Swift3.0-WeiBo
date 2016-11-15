//
//  PicPickerCollectionView.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/15.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

fileprivate let picPickerCell = "picPickerCell"
fileprivate let edgeMargin: CGFloat = 15
class PicPickerCollectionView: UICollectionView {

    // MARK:- 定义属性
    var images:[UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        //1.设置collectionView的layout
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (UIScreen.main.bounds.width - 4 * edgeMargin) / 3
        layout.itemSize = CGSize(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = edgeMargin
        layout.minimumInteritemSpacing = edgeMargin
//        layout.scrollDirection = .horizontal
        //2.注册单元格
        register(UINib.init(nibName: "PicPickerViewCell", bundle: nil), forCellWithReuseIdentifier: picPickerCell)
        dataSource = self
        //3.设置collectionView的内边距
        contentInset = UIEdgeInsets(top: edgeMargin, left: edgeMargin, bottom: 0, right: edgeMargin)
    }
}

// MARK:- 数据源方法
extension PicPickerCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCell, for: indexPath) as! PicPickerViewCell
        //2.给cell设置数据
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        return cell
    }
}



