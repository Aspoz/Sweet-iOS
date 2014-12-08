//
//  CaseViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 25-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class CaseViewController: UIViewController, DictControllerProtocol, UITableViewDelegate, UITableViewDataSource{
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var documentsTableView: UITableView!
    var caseitem : CaseItem?
    
    var documents = [Document]()
    lazy var api : DictController = DictController(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = caseitem?.title
        
        if caseitem != nil {
            api.documentsUrl(caseitem!.id)
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DocumentCell") as UITableViewCell
        let document = documents[indexPath.row]
        cell.textLabel?.text = document.title
        return cell
    }
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var documentViewController: DocumentViewController = segue.destinationViewController as DocumentViewController
        var documentIndex = documentsTableView!.indexPathForSelectedRow()!.row
        var selectedDocument = self.documents[documentIndex]
        documentViewController.document = selectedDocument
    }
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var document = documents[indexPath.row]
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
