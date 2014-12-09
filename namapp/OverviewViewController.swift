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
            self.searchJob("")
        })
    }
    
    @IBAction func filter(sender: UISegmentedControl) {
        if filterControl.selectedSegmentIndex == 0 {
            searchJob("")
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
        if type != "" {
            self.filteredCases.removeAllObjects()
            for filtercase in cases {
                if filtercase.casetype == type {
                    filteredCases.addObject(filtercase)
                }
            }
        } else {
            if filteredCases != nil {
                self.filteredCases.removeAllObjects()
            }
            for filtercase in cases {
                filteredCases.addObject(filtercase)
            }
            self.overviewTableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredCases == nil {
            return self.cases.count
        } else {
            return self.filteredCases.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OverviewCell") as OverviewCell
        let caseitem = filteredCases[indexPath.row] as CaseItem
        
        cell.addDataInCellsForCase(caseitem)
//        cell.textLabel?.text = caseitem.title
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "tabview" {
            var tabBarC : UITabBarController = segue.destinationViewController as UITabBarController
            var desView: CaseViewController = tabBarC.viewControllers?.first as CaseViewController
            var indexPath = self.overviewTableView!.indexPathForSelectedRow()!
            let selectedCase = filteredCases[indexPath.row] as CaseItem
            desView.caseitem = selectedCase
            
            var desview2: CommentViewController = tabBarC.viewControllers?.last as CommentViewController
            desview2.caseitem = selectedCase
        }
    }
    
    @IBAction func logoutTapped(sender: UIBarButtonItem) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}

// Declare OverviewCell: UITableViewCell
class OverviewCell: UITableViewCell {
    
    // Set cell variables
    @IBOutlet weak var CaseTitle: UILabel!
    @IBOutlet weak var CaseType: UILabel!
    @IBOutlet weak var CaseStatusColor: UIView!
    
    // Fill in Prototype cells for Case Overview with data
    func addDataInCellsForCase(caseitem: CaseItem) {
        CaseTitle.text = caseitem.title
        CaseType.text = caseitem.casetype
        
        // Check what status it is
        switch caseitem.status {
        case "In progress":
            // If 'In progress' set CaseStatusColor to green
            CaseStatusColor.backgroundColor = UIColor.colorWithRGBHex(0x6ABF28)
            
        case "Open":
            // If 'Open' set CaseStatusColor to blue
            CaseStatusColor.backgroundColor = UIColor.colorWithRGBHex(0x4A90E2)
            
        default:
            // If its anything else (closed) set CaseStatusColor to grey
            CaseStatusColor.backgroundColor = UIColor.colorWithRGBHex(0xCCCCCC)
        }
    }
}