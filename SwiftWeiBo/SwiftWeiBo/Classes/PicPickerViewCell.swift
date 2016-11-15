//
//  PicPickerViewCell.swift
//  SwiftWeiBo
//
//  Created by kjlink on 2016/11/15.
//  Copyright © 2016年 kjlink. All rights reserved.
//

import UIKit

class PicPickerViewCell: UICollectionViewCell {
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    var image: UIImage? {
        didSet {
            if image != nil {
                addPhotoBtn.setBackgroundImage(image, for: .normal)
                addPhotoBtn.isUserInteractionEnabled = false
            } else {
                addPhotoBtn.setBackgroundImage(#imageLiteral(resourceName: "compose_pic_add"), for: .normal)
                addPhotoBtn.isUserInteractionEnabled = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func addPhotoClick() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PicPickerAddPhotoNote), object: nil)
    }

}
