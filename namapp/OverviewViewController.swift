//
//  OverviewViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 24-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class OverviewViewController: ApplicationViewController, UITableViewDataSource, UITableViewDelegate, ArrayControllerProtocol {
    
    @IBOutlet weak var filterControl: UISegmentedControl!
    @IBOutlet weak var overviewTableView: UITableView!
    @IBOutlet weak var filterBG: UIView!
    
    var cases = [CaseItem]()
    var api : ArrayController?
    var filteredCases: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = ArrayController(delegate: self)
        api!.casesUrl()
        
//        navigationController!.navigationBar.translucent = false
        
        applyCustomShadow(filterBG, shadowWidth: 0, shadowHeight: -2, radius: 4)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.overviewTableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (Backend().isLoggedIn() == false) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewcontroller = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController
            presentViewController(viewcontroller, animated: true, completion: nil)
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
        
        switch filterControl.selectedSegmentIndex {
        case 0:
            searchJob("")
        case 1:
            searchJob("RFC")
        case 2:
            searchJob("NFI")
        case 3:
            searchJob("RFA")
        case 4:
            searchJob("Info")
        default:
            searchJob("")
        }
        
        self.overviewTableView.reloadData()
    } // filter segemented control
    
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
        
        cell.removeCaseSelectedStyling()
        cell.addDataInCellsForCase(caseitem)
        
        if(filteredCases.count > 0) {
            if(indexPath.row == (filteredCases.count-1)) {
                // if it's the last cell, add shadow
                applyPlainShadow(cell)
            } else {
                removeShadow(cell)
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow()
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as OverviewCell
        currentCell.addCaseSelectedStyling()
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