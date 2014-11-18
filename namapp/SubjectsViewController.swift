//
//  SubjectsViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 29-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class SubjectsViewController: UIViewController, APIControllerProtocol, UITableViewDelegate, UITableViewDataSource{
    
    var meeting: Meeting?
    var subjects = [Subject]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subjectsTableView: UITableView!
    lazy var api : APIController = APIController(delegate: self)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.meeting?.title
        
        if self.meeting != nil {
            api.subjectsUrl(self.meeting!.id)
            println(self.meeting!.id)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SubjectCell") as SubjectCell
        let subject = subjects[indexPath.row]
        cell.titleLabel.text = subject.title
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var subject = subjects[indexPath.row]
    }
    
    // MARK: APIControllerProtocol
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSDictionary = results as NSDictionary
        dispatch_async(dispatch_get_main_queue(), {
            self.subjects = Subject.subjectsWithJSON(resultsArr)
            self.subjectsTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
}