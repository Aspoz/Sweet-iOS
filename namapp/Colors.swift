//
//  Colors.swift
//  namapp
//
//  Created by Boyd Dames on 15-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension UIColor {
    class func namGreenColor() -> UIColor {
        return UIColor.colorWithRGBHex(0x6ABF28)
    }
    
    class func namBlueColor() -> UIColor {
        return UIColor.colorWithRGBHex(0x005193)
    }
    
    class func contentColor() -> UIColor {
        return UIColor.colorWithRGBHex(0x555555)
    }
    
    class func inProgressCaseColor() -> UIColor {
        return UIColor.namGreenColor()
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
