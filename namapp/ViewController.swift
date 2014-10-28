//
//  ViewController.swift
//  beta
//
//  Created by Jordi Wippert on 08-10-14.
//  Copyright (c) 2014 JW. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var docTableView: UITableView!
    var tableData = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let urlPath = "https://dl.dropboxusercontent.com/u/45250625/meeting.json"
        let url: NSURL = NSURL(string: urlPath)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            let jsonObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
            if let meetingsArray = jsonObject as? NSArray{
            //          println(meetingsArray)
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableData = meetingsArray
                    self.docTableView!.reloadData()
                })
                if let aMeeting = meetingsArray[0] as? NSDictionary{
//              println(aMeeting)           //
                    if let files = aMeeting["files"] as? NSArray{
//                  println(files)
                        if let file = files[0] as? NSDictionary {
//                      println(file)
                          if let fileTitle = file["title"] as? String{
                        println(fileTitle)
                            }
                        }
                    }
                }
            }
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let rowData: NSDictionary = self.tableData[indexPath.row] as NSDictionary
        
        cell.textLabel.text = rowData["title"] as? String
        cell.detailTextLabel?.text = rowData["type"] as? String

        return cell
    }
    
    
}

