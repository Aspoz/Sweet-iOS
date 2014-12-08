//
//  OverviewViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 24-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ArrayControllerProtocol {

    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var overviewTableView: UITableView!
    
    var cases = [CaseItem]()
    var api : ArrayController?
    var filteredCases: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = ArrayController(delegate: self)
        api!.casesUrl()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
        self.useridLabel.text = prefs.valueForKey("USERNAME") as NSString
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func didReceiveAPIResults(results: NSArray) {
        var resultsArr: NSArray = results as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.cases = CaseItem.casesWithJSON(resultsArr)
            self.filteredCases = NSMutableArray()
            self.filteredCases.addObject(self.cases)
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })

    }
    
    @IBAction func filter(sender: UISegmentedControl) {
        if filterControl.selectedSegmentIndex == 0 {
        } else if filterControl.selectedSegmentIndex == 1 {
            searchJob("RFC")
        } else if filterControl.selectedSegmentIndex == 2 {
            searchJob("NFI")
        } else if filterControl.selectedSegmentIndex == 3 {
            searchJob("RFA")
        } else if filterControl.selectedSegmentIndex == 4 {
            searchJob("Info")
        }
        self.overviewTableView.reloadData()
    }
    
    func searchJob(type: String) {
        self.filteredCases.removeAllObjects()
        for filtercase in cases {
            if filtercase.casetype == type {
                filteredCases.addObject(filtercase)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCases == nil {
            return cases.count
        } else {
            return filteredCases.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell") as UITableViewCell
        if filteredCases == nil {
            let caseitem = cases[indexPath.row] as CaseItem
        } else {
        let caseitem = filteredCases[indexPath.row] as CaseItem
            cell.textLabel?.text = caseitem.title
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tabview" {
            var tabBarC : UITabBarController = segue.destinationViewController as UITabBarController
            var desView: CaseViewController = tabBarC.viewControllers?.first as CaseViewController
            var indexPath = self.overviewTableView!.indexPathForSelectedRow()!
            let selectedCase = filteredCases[indexPath.row] as CaseItem
            desView.caseitem = selectedCase
        }
    }
    

    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}