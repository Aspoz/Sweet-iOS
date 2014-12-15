//
//  Colors.swift
//  namapp
//
//  Created by Boyd Dames on 15-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIColor

extension UIColor {
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
