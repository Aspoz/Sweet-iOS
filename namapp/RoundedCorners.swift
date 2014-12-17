//
//  RoundedCorners.swift
//  namapp
//
//  Created by Boyd Dames on 16-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension UIView {
    func roundedCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func makeCircle() {
        var radius:CGFloat = self.frame.width/2.0
        self.roundedCorners(radius)
    }
}
