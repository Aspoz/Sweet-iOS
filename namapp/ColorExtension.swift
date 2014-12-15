//
//  ColorExtension.swift
//  namapp
//
//  Created by Boyd Dames on 08-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension UIColor {
    class func colorWithRGBHex(hex: Int, alpha: Float = 1.0) -> UIColor {
        let r = Float((hex >> 16) & 0xFF)
        let g = Float((hex >> 8) & 0xFF)
        let b = Float((hex) & 0xFF)
        
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue:CGFloat(b / 255.0), alpha: CGFloat(alpha))
    }
    
    class func colorWithRGBHexWithAlpha(rgbValue: UInt32, alpha: Double)-> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    class func inProgressCaseColor() -> UIColor {
        return UIColor.colorWithRGBHex(0x6ABF28)
    }
    
    class func openCaseColor() -> UIColor {
        return UIColor.colorWithRGBHex(0x4A90E2)
    }
    
    class func closedCaseColor() -> UIColor {
        return UIColor.colorWithRGBHex(0xCCCCCC)
    }
    
    class func caseSelectedColor() -> UIColor {
        return UIColor.colorWithRGBHex(0xF6F6F6)
    }

}