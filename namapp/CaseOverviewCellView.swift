//
//  CaseOverviewCellView.swift
//  namapp
//
//  Created by Boyd Dames on 15-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

// class OverviewCell for the CasesOverviewController for each cell
class OverviewCell: UITableViewCell {
    
    // Set cell variables
    @IBOutlet weak var CaseBG: UIView!
    @IBOutlet weak var CaseTitle: UILabel!
    @IBOutlet weak var CaseType: UILabel!
    @IBOutlet weak var CaseStatusColor: UIView!
    
    // Fill in Prototype cells for Case Overview with data
    func addDataInCellsForCase(caseitem: CaseItem) {
        CaseTitle.text = caseitem.title
        CaseType.text = caseitem.casetype.uppercaseString
        
        // Check what status it is
        switch caseitem.status {
        case "In progress":
            CaseStatusColor.backgroundColor = UIColor.inProgressCaseColor()
            
        case "Open":
            CaseStatusColor.backgroundColor = UIColor.openCaseColor()
            
        default:
            CaseStatusColor.backgroundColor = UIColor.closedCaseColor()
        }
    }
    
    func addCaseSelectedStyling() {
        self.backgroundColor = UIColor.caseSelectedColor()
        self.CaseBG.backgroundColor = UIColor.caseSelectedColor()
    }
    
    func removeCaseSelectedStyling() {
        self.backgroundColor = UIColor.whiteColor()
        self.CaseBG.backgroundColor = UIColor.whiteColor()
    }
    
}
