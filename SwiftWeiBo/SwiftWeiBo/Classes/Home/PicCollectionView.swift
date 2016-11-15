//
//  PicCollectionView.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/14.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {
    // MARK:- 定义属性
    var picUrls: [URL] = [URL]() {
        didSet {
            reloadData()
        }
    }
    
    // MARK:- 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
    }
}

// MARK:- collectionView的数据源方法
extension PicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //1.获取cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCollectionViewCell
        //2.给cell设置数据
        cell.picUrl = picUrls[indexPath.item]
        
        return cell
    }
}

class PicCollectionViewCell: UICollectionViewCell {
    // MARK:- 定义模型属性
    var picUrl: URL? {
        didSet {
            guard let picUrl = picUrl else {
                return
            }
            iconView.sd_setImage(with: picUrl, placeholderImage: #imageLiteral(resourceName: "empty_picture"))
        }
    }
    @IBOutlet weak var iconView: UIImageView!
    
}



