//
//  CaseViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 25-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class CaseViewController: UIViewController, DictControllerProtocol, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var emptyCaseViewBG: UIImageView!
    @IBOutlet weak var emptyCaseViewText: UILabel!
    @IBOutlet weak var caseType: UILabel!
    @IBOutlet weak var caseStatus: UILabel!
    @IBOutlet weak var documentsTableView: UITableView!
    var caseitem : CaseItem?
    
    var documents = [Document]()
    lazy var api : DictController = DictController(delegate: self)
    
    override func viewDidLoad() {
        self.tabBarController?.title = "Case: \(caseitem!.title)"
        super.viewDidLoad()
        
        setStatusAndTypeForCase(caseitem!.status, type: caseitem!.casetype)
        
        if caseitem != nil {
            api.documentsUrl(caseitem!.id)
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(documents.count > 0) {
            hideTextAndImageForEmptyCase()
        } else {
            showTextAndImageForEmptyCase()
        }
        
        return documents.count
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DocumentCell") as DocumentCell
        let document = documents[indexPath.row]
        
        cell.removeCaseSelectedStyling()
        cell.addDataInCellsForDocuments(document)
        
        if(documents.count > 0) {
            if(indexPath.row == (documents.count-1)) {
                // if it's the last cell, add shadow
                applyPlainShadow(cell)
            } else {
                removeShadow(cell)
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var document = documents[indexPath.row]
        let indexPath = tableView.indexPathForSelectedRow()
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as DocumentCell
        
        currentCell.addCaseSelectedStyling()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var documentViewController: DocumentViewController = segue.destinationViewController as DocumentViewController
        var documentIndex = documentsTableView!.indexPathForSelectedRow()!.row
        var selectedDocument = self.documents[documentIndex]
        documentViewController.document = selectedDocument
    }
    
    func setStatusAndTypeForCase(status: String, type: String) {
        caseStatus.text = status.uppercaseString
        caseType.text = type.uppercaseString
    }
    
    func showTextAndImageForEmptyCase() {
        emptyCaseViewBG.alpha = 1
        emptyCaseViewText.alpha = 1
    }
    
    func hideTextAndImageForEmptyCase() {
        emptyCaseViewBG.alpha = 0
        emptyCaseViewText.alpha = 0
    }
    
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // REMOVE LATER! MAKE THIS GLOBAL FUNCTION!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // Function to apply pre-built shadow for cells on an UIView
    func applyPlainShadow(view: UIView) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
    }
    
    // Function to apply custom shadow on an UIView
    func applyCustomShadow(view: UIView, shadowWidth: Int, shadowHeight: Int, radius: CGFloat) {
        var layer = view.layer
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = radius
    }
    
    func removeShadow(view: UIView) {
        view.layer.shadowOpacity = 0.0
    }
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    // END GLOBAL FUNCTION!!!!!!!!!!!!!!!!!!!!!!!!
    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSDictionary = results as NSDictionary
        dispatch_async(dispatch_get_main_queue(), {
            self.documents = Document.documentsWithJSON(resultsArr)
            self.documentsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}

class DocumentCell: UITableViewCell {
    
    // Set cell variables
    @IBOutlet weak var fileBG: UIView!
    @IBOutlet weak var fileIcon: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileUpdatedDate: UILabel!
    
    
    // Fill in Prototype cells for Case Overview with data
    func addDataInCellsForDocuments(document: Document) {
        fileName.text = document.title
        fileUpdatedDate.text = document.updated_at
    }
    
//        fileUpdatedDate = document.updated_at
//        CaseTitle.text = caseitem.title
//        CaseType.text = caseitem.casetype
//        
//        // Check what status it is
//        switch caseitem.status {
//        case "In progress":
//            // If 'In progress' set CaseStatusColor to green
//            CaseStatusColor.backgroundColor = UIColor.colorWithRGBHex(0x6ABF28)
//            
//        case "Open":
//            // If 'Open' set CaseStatusColor to blue
//            CaseStatusColor.backgroundColor = UIColor.colorWithRGBHex(0x4A90E2)
//            
//        default:
//            // If its anything else (closed) set CaseStatusColor to grey
//            CaseStatusColor.backgroundColor = UIColor.colorWithRGBHex(0xCCCCCC)
//        }
//    }
//    
    func addCaseSelectedStyling() {
        self.backgroundColor = UIColor.colorWithRGBHex(0xF6F6F6)
        self.fileBG.backgroundColor = UIColor.colorWithRGBHex(0xF6F6F6)
    }
    
    func removeCaseSelectedStyling() {
        self.backgroundColor = UIColor.whiteColor()
        self.fileBG.backgroundColor = UIColor.whiteColor()
    }
    
}
