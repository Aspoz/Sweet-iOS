//
//  placeholderTextView.swift
//  namapp
//
//  Created by Boyd Dames on 16-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension UITextView {
    func addPlaceholderIfEmpty(message: String) {
        if (self.text == "") {
            self.text = message
            self.textColor = UIColor.lightGrayColor()
        } else {
            self.text = ""
            self.textColor = UIColor.blackColor()
        }
    }
}
