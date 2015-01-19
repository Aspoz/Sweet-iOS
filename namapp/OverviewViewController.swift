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
    @IBOutlet weak var inProgressStatusColor: UIView!
    @IBOutlet weak var openStatusColor: UIView!
    @IBOutlet weak var closedStatusColor: UIView!
    
    let backend = Backend()
    let spinner = LoadingSpinner()
    
    var cases = [CaseItem]()
    var api : ArrayController?
    var filteredCases: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewdidload")

        spinner.startLoadingSpinner(view)
        
        api = ArrayController(delegate: self)
        api!.getAllCases({ () -> Void in
            println("get all functions from api")
            dispatch_async(dispatch_get_main_queue()) {
                println("API Success Callback")
                self.spinner.stopLoadingSpinner()
            }
        }, error: { (err) -> Void in
            self.backend.logout()
            self.performSegueWithIdentifier("goto_login", sender: self)
        })
        
        inProgressStatusColor.backgroundColor       = UIColor.inProgressCaseColor()
        openStatusColor.backgroundColor             = UIColor.openCaseColor()
        closedStatusColor.backgroundColor           = UIColor.closedCaseColor()
        
        filterBG.applyCustomShadow(0, shadowHeight: -2, radius: 4)
    }

    override func viewWillAppear(animated: Bool) {
        self.overviewTableView.reloadData()
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
            self.searchJob("")
            println("func did receive api results")
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
                cell.applyPlainShadow()
            } else {
                cell.removeShadow()
            }
        }
        println("fill table cells")

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
        backend.logout()
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}