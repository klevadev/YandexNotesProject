//
//  ImageLoader.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 21/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

class ImagesLoader {
    
    var images = [UIImage]()
    
    func add(_ image: UIImage) {
        images.append(image)
    }
    
    func count() -> Int {
        return images.count
    }
    
    subscript(index: Int) -> UIImage? {
        return images[index]
    }
}
