//
//  DocumentCellView.swift
//  namapp
//
//  Created by Boyd Dames on 15-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

// class DocumentCell for the CaseViewController for each cell
class DocumentCell: UITableViewCell {
    
    // Set cell variables
    @IBOutlet weak var fileBG: UIView!
    @IBOutlet weak var fileIcon: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileUpdatedDate: UILabel!
    
    // Fill in Prototype cells for Case Overview with data
    func addDataInCellsForDocuments(document: Document) {
        fileName.text = document.title
        fileUpdatedDate.text = document.updated_at.formatDate()
    }
    
    func addCaseSelectedStyling() {
        self.backgroundColor = UIColor.caseSelectedColor()
        self.fileBG.backgroundColor = UIColor.caseSelectedColor()
    }
    
    func removeCaseSelectedStyling() {
        self.backgroundColor = UIColor.whiteColor()
        self.fileBG.backgroundColor = UIColor.whiteColor()
    }
    
}
