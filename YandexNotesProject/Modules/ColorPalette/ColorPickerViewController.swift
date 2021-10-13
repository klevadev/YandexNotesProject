//
//  ColorPickerViewController.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 21/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

protocol ChangeColorDelegate {
    func userSelectedAColor(_ color: UIColor)
}

class ColorPickerViewController: UIViewController, ColorPickerViewDelegate {
    
    @IBOutlet weak var paletteView: ColorPickerView!
    
    var delegate: ChangeColorDelegate?
    var selectedColor: UIColor? {
        didSet {
            navigationItem.rightBarButtonItem?.isEnabled = selectedColor != nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        paletteView.delegate = self
        
        let rightButton = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(onDoneButtonTap))
        
        if let selectedColor = selectedColor {
            paletteView.setCurrentColor(color: selectedColor)
            rightButton.isEnabled = true
        } else {
            rightButton.isEnabled = false
        }
        
        navigationItem.rightBarButtonItem = rightButton

        // Do any additional setup after loading the view.
    }
    
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func onDoneButtonTap() {
        if let delegate = delegate,
            let selectedColor = selectedColor {
            delegate.userSelectedAColor(selectedColor)
        }
        goBack()
    }
    
    func onUserPickedColor(color: UIColor) {
        selectedColor = color
    }

}
