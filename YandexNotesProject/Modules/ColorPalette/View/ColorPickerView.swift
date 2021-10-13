//
//  ColorPickerView.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 13/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

protocol ColorPickerViewDelegate {
    func onUserPickedColor(color: UIColor)
}

@IBDesignable
class ColorPickerView: UIView {
    
    @IBOutlet weak var paletteView: PaletteView!
    @IBOutlet weak var boxColor: UIView!
    @IBOutlet weak var textColor: UILabel!
    @IBOutlet weak var chooseViewColor: UIView!
    @IBOutlet weak var slider: UISlider!
    
    var delegate: ColorPickerViewDelegate?
    
    var selectedColor: UIColor? {
        didSet {
            updateUI()
            delegate?.onUserPickedColor(color: paletteView.choosedColor)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let xibView = loadViewFromXib()
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        chooseViewColor.layer.borderColor = UIColor.black.cgColor
        chooseViewColor.clipsToBounds = true
        chooseViewColor.layer.borderWidth = 1
        chooseViewColor.layer.cornerRadius = 5
        updateColorText()
        addBottomBorder()
        paletteView.layer.borderColor = UIColor.black.cgColor
        paletteView.layer.borderWidth = 1
        self.addSubview(xibView)
    
    }
    
    private func addBottomBorder() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: boxColor.frame.height - 1, width: boxColor.frame.width, height: 1)
        border.backgroundColor = UIColor.black.cgColor
        boxColor.layer.addSublayer(border)
    }
    
    private func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorPalette", bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first! as! UIView
    }
    
    @IBAction func sliderChangedValue(_ sender: UISlider) {
        paletteView.paletteBrightness = sender.value
        selectedColor = paletteView.choosedColor
        updateColorText()
    }
    
    @IBAction func onClickColorPick(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: paletteView)
        updateColor(point: point)
    }
    
    @IBAction func onMoveColorPick(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let gesturePoint = sender.location(in: paletteView)
            updateColor(point: gesturePoint)
        }
    }
    
    private func updateUI() {
        boxColor.backgroundColor = selectedColor
        textColor.text = selectedColor!.serialize()
    }
    
    private func updateColor(point: CGPoint) {
        paletteView.setChoosedColor(point: point)
        selectedColor = paletteView.choosedColor
        updateColorText()
    }
    
    private func updateColorText() {
        let currentColor = paletteView.choosedColor
        boxColor.backgroundColor = currentColor
        textColor.text = currentColor.serialize()
    }
    
    public func setCurrentColor(color: UIColor) {
        paletteView.choosedColor = color
        selectedColor = color
    }
    
}
