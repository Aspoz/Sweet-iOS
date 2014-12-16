//
//  ApplyShadowToUIView.swift
//  namapp
//
//  Created by Boyd Dames on 16-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyPlainShadow() {
        var layer = self.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
    }

    // Function to apply custom shadow on an UIView
    func applyCustomShadow(shadowWidth: Int, shadowHeight: Int, radius: CGFloat) {
        var layer = self.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = radius
    }

    func removeShadow() {
        self.layer.shadowOpacity = 0.0
    }
    
}
