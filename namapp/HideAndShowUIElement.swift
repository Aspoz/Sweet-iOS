//
//  HideAndShowUIElement.swift
//  namapp
//
//  Created by Boyd Dames on 16-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension UIView {
    func showElement() {
        self.alpha = 1
    }
    
    func hideElement() {
        self.alpha = 0
    }
}