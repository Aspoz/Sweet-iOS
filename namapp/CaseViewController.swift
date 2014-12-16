//
//  CaseViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 25-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class CaseViewController: ApplicationViewController, DictControllerProtocol, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var emptyCaseViewBG: UIImageView!
    @IBOutlet weak var emptyCaseViewText: UILabel!
    @IBOutlet weak var caseType: UILabel!
    @IBOutlet weak var caseStatus: UILabel!
    @IBOutlet weak var caseStatusColor: UIView!
    @IBOutlet weak var documentsTableView: UITableView!
    var caseitem : CaseItem?
    
    var documents = [Document]()
    lazy var api : DictController = DictController(delegate: self)
    
    override func viewDidLoad() {
        self.tabBarController?.title = "Case: \(caseitem!.title)"
        super.viewDidLoad()
        
        caseType.text = caseitem!.casetype.uppercaseString
        caseStatus.text = caseitem!.status.uppercaseString
        caseStatusColor.addStatusColor(caseitem!)
        
        if caseitem != nil {
            api.documentsUrl(caseitem!.id)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(documents.count > 0) {
            emptyCaseViewBG.hideElement()
            emptyCaseViewText.hideElement()
        } else {
            emptyCaseViewBG.showElement()
            emptyCaseViewText.showElement()
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
    
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSDictionary = results as NSDictionary
        dispatch_async(dispatch_get_main_queue(), {
            self.documents = Document.documentsWithJSON(resultsArr)
            self.documentsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}