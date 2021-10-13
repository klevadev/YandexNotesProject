//
//  PaletteView.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 14/07/2019.
//  Copyright © 2019 phenomendevelopers. All rights reserved.
//

import UIKit

@IBDesignable
class PaletteView: UIView {
    
    var choosedColor: UIColor = .red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var paletteBrightness: Float = 255.0 {
        didSet {
            updateColor()
            setNeedsDisplay()
        }
    }
    
    var curBrightess: CGFloat?
    
    private var paletteWithCustomColor: UIImage? = nil
    
    func setChoosedColor (point: CGPoint) {
        let minX = min(point.x, self.bounds.width)
        let minY = min(point.y, self.bounds.height)
        let maxX = max(minX, 0)
        let maxY = max(minY, 0)
        let choosed = CGPoint(x: maxX, y: maxY)
        choosedColor = getPointColor(point: choosed)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let palette = createGradient(rect: rect)
        palette.draw(in: rect)
        
        let brightnessLayer = addBrightnessLayer(rect: rect)
        brightnessLayer.draw(in: rect)
        
        let position = getColorPosition(color: choosedColor)
        drawTargetPoint(point: position)
    }
    
    private func createGradient(rect: CGRect) -> UIImage {
        if let palette = paletteWithCustomColor {
            return palette
        }
        
        let paletteRender = UIGraphicsImageRenderer(size: self.bounds.size)
        let palette = paletteRender.image { context in
            let brightness = CGFloat(1.0)
            let stepY = Double (rect.height) / 255.0
            let lineWidth = Double (rect.width / 360.0)
            for x: Double in stride (from: 0.0, to: 360.0, by: 1.0) {
                let fX = x * lineWidth
                let hue = CGFloat (x / 360.0)
                for y: Double in stride (from: 0.0, to: 255.0, by: 1.0) {
                    let saturation = CGFloat (1.0 - y / 255.0)
                    let fY = y * stepY
                    let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                    context.cgContext.setFillColor(color.cgColor)
                    context.cgContext.fill(CGRect(x: fX, y: fY, width: lineWidth + 2.0, height: stepY))
                }
            }
        }
        paletteWithCustomColor = palette
        return palette
    }
    
    private func addBrightnessLayer(rect: CGRect) -> UIImage {
        let brightness = CGFloat(1.0 - paletteBrightness / 255.0)
        let paletteRender = UIGraphicsImageRenderer(size: self.bounds.size)
        let palette = paletteRender.image { context in
            let color = UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: brightness)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(CGRect(x: 0, y: 0, width: rect.width, height: rect.height))
        }
        return palette
        
    }
    
    private func drawTargetPoint(point: CGPoint) {
        let radius = CGFloat(10)
        let lineLength = CGFloat(5)
        let path = UIBezierPath()
        path.lineWidth = 1
        
        path.move(to: CGPoint(x: point.x + radius, y: point.y))
        path.addArc(withCenter: point, radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
        path.move(to: CGPoint(x: point.x + radius, y: point.y))
        path.addLine(to: CGPoint(x: point.x + radius + lineLength, y: point.y))
        path.move(to: CGPoint(x: point.x, y: point.y + radius))
        path.addLine(to: CGPoint(x: point.x, y: point.y + radius + lineLength))
        path.move(to: CGPoint(x: point.x - radius, y: point.y))
        path.addLine(to: CGPoint(x: point.x - radius - lineLength, y: point.y))
        path.move(to: CGPoint(x: point.x, y: point.y - radius))
        path.addLine(to: CGPoint(x: point.x, y: point.y - radius - lineLength))
        let color = UIColor.black
        color.set()
        path.stroke()
    }
    
    func getPointColor(point: CGPoint) -> UIColor {
        let scaleX = 360.0 / self.bounds.width
        let scaleY = 255.0 / self.bounds.height
        let hue = CGFloat((scaleX * point.x) / 360.0)
        
        let saturation = CGFloat(1.0 - (scaleY * point.y) / 255.0)
        let brightness = CGFloat(paletteBrightness / 255.0)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    private func updateColor() {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        choosedColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newBrightness = CGFloat(paletteBrightness / 255.0)
        choosedColor = UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
        
        curBrightess = newBrightness
    }
    
    func getColorPosition (color: UIColor) -> CGPoint {
        let scaleX = 360.0 / self.bounds.width
        let scaleY = 255.0 / self.bounds.height
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return CGPoint(x: (hue / scaleX * 360.0) , y: ((1.0 - saturation) / scaleY) * 255.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        paletteWithCustomColor = nil
        self.setNeedsDisplay()
    }
    
}
