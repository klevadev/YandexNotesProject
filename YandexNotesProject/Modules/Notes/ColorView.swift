//
//  ColorView.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 14/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

@IBDesignable
class ColorView: UIView {
    @IBInspectable var isChecked: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var isGradient: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBorder()
    }
    
    private func addBorder() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func draw (_ rect: CGRect) {
        super.draw(rect)
        
        if (isGradient) {
            let image = UIImage(named: "gradients")
            image?.draw(in: rect)
        }

        guard (isChecked) else {
            return
        }

        let lineSize: CGFloat = 2.0
        let checkSize: Float = 4
        let radius = Float(checkSize * 2 + 2)
        let centerX: Float = Float(rect.width) - radius - Float(lineSize) - 2.0
        let centerY: Float = radius + Float(lineSize) + 2.0
        let path = UIBezierPath()

        let color = UIColor.black
        color.set()

        path.lineWidth = lineSize
        path.move(to: CGPoint(x: CGFloat(centerX - checkSize - checkSize / 2), y: CGFloat(centerY)))
        path.addLine(to: CGPoint(x: CGFloat(centerX - checkSize / 2), y: CGFloat(centerY + checkSize)))
        path.addLine(to: CGPoint(x: CGFloat(centerX + checkSize * 2 - checkSize / 2), y: CGFloat(centerY - checkSize)))
        path.move(to: CGPoint(x: CGFloat(centerX + radius), y: CGFloat(centerY)))
        path.addArc(withCenter: CGPoint(x: CGFloat(centerX), y: CGFloat(centerY)), radius: CGFloat(radius), startAngle: 0, endAngle: 360, clockwise: true)
        path.stroke()
    }
}

