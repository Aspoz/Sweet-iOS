//
//  OverviewViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 24-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ArrayControllerProtocol {
    
    @IBOutlet weak var overviewTableView: UITableView!
    var cases = [CaseItem]()
    var api : ArrayController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = ArrayController(delegate: self)
        api!.casesUrl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cases.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell") as UITableViewCell
        let caseitem = cases[indexPath.row]
        cell.textLabel.text = caseitem.title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var caseViewController: CaseViewController = segue.destinationViewController as CaseViewController
        var caseIndex = overviewTableView!.indexPathForSelectedRow()!.row
        var selectedCase = self.cases[caseIndex]
        caseViewController.caseitem = selectedCase
    }
    
    func didReceiveAPIResults(results: NSArray) {
        var resultsArr: NSArray = results as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.cases = CaseItem.casesWithJSON(resultsArr)
            self.overviewTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}