//
//  Extension+UIColor.swift
//  YandexNotesProject
//
//  Created by Lev Kolesnikov on 13.10.2021.
//  Copyright © 2021 phenomendevelopers. All rights reserved.
//
import UIKit


extension UIColor {
    var rgba: [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
    
    
    static func rgbaToUIColor (_ rgba: [CGFloat]) -> UIColor {
        let color = UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])
        return color
    }
    
    var brightness: CGFloat? {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        
        guard self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
            return nil
        }
        
        return brightness
    }
    
    func serialize() -> String {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let redGrid = String(format:"%02X", Int(red * 255))
            let greenGrid = String(format:"%02X", Int(green * 255))
            let blueGrid = String(format:"%02X", Int(blue * 255))
            
            return "#\(redGrid)\(greenGrid)\(blueGrid)"
        }
}
