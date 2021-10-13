//
//  GalleryCollectionViewCell.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 21/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shadowView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
