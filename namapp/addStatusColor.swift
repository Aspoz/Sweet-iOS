//
//  addStatusColor.swift
//  namapp
//
//  Created by Boyd Dames on 16-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension UIView {
    func addStatusColor(caseItem: CaseItem) {
        switch caseItem.status {
        case "In progress":
            self.backgroundColor = UIColor.inProgressCaseColor()
            
        case "Open":
            self.backgroundColor = UIColor.openCaseColor()
            
        default:
            self.backgroundColor = UIColor.closedCaseColor()
        }
    }
}
