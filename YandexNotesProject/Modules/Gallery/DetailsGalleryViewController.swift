//
//  SlideGalleryViewController.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 21/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

class DetailsGalleryViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var gallery: ImagesLoader?
    private var isCalculated = false
    var currentImageIndex = 0
    var lastOpenedPage: Int?
    
    private var imageViews = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.isPagingEnabled = true
        
        if let images = gallery?.images {
            for image in images {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                imageViews.append(imageView)
                scrollView.addSubview(imageView)
            }
        }

        // Do any additional setup after loading the view.
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for (index, imageView) in imageViews.enumerated() {
            imageView.frame.size = scrollView.frame.size
            imageView.frame.origin.x = scrollView.frame.width * CGFloat(index)
            imageView.frame.origin.y = 0
        }
        
        let contentWidth: CGFloat
        
        if let images = gallery?.images {
            contentWidth = scrollView.frame.width * CGFloat(images.count)
        } else {
            contentWidth = scrollView.frame.width
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
        
        scrollView.setContentOffset(CGPoint(x: imageViews[currentImageIndex].frame.minX, y: 0), animated: false)
        isCalculated = true
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        isCalculated = false
    }
}

// MARK: - UINavigationControllerDelegate
extension DetailsGalleryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isCalculated {
            let pageIndex = scrollView.contentOffset.x / scrollView.frame.width
            let roundedPageIndex = Int(pageIndex.rounded())
            currentImageIndex = roundedPageIndex
        }
    }
}
