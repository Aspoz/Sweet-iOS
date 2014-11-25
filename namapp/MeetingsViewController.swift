//
//  MeetingsViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 29-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class MeetingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ArrayControllerProtocol {
    
    @IBOutlet var meetingsTableView: UITableView!
    var meetings = [Meeting]()
    var api : ArrayController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = ArrayController(delegate: self)
        api!.meetingsUrl()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meetings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MeetingCell") as UITableViewCell
        
        let meeting = self.meetings[indexPath.row]
        cell.textLabel.text = meeting.title
        
        // Get the formatted price string for display in the subtitle
//        let date = meeting.date
//        cell.detailTextLabel?.text = date
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var subjectsViewController: SubjectsViewController = segue.destinationViewController as SubjectsViewController
        var meetingIndex = meetingsTableView!.indexPathForSelectedRow()!.row
        var selectedMeeting = self.meetings[meetingIndex]
        subjectsViewController.meeting = selectedMeeting
    }
    
    func didReceiveAPIResults(results: NSArray) {
        //        var resultsArr: NSArray = results as NSArray
        var resultsArr: NSArray = results as NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.meetings = Meeting.meetingsWithJSON(resultsArr)
            self.meetingsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
}