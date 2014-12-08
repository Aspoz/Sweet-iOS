//
//  NoteViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 03-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController, DictControllerProtocol, UITableViewDelegate, UITableViewDataSource{
    var document: Document?
    var notes = [Note]()
    
    var docId:String!
    var ID:Int!
    var docTitle:String!
    
    @IBOutlet weak var documentId: UILabel!
    @IBOutlet weak var noteText: UITextField!
    @IBOutlet weak var documentTitle: UILabel!
    @IBOutlet weak var userId: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
            documentId.text = docId
            documentTitle.text = docTitle
            println(docId)
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let user_idint:Int = prefs.integerForKey("USER_ID") as Int
            var user_id = String(user_idint)
            userId.text = user_id
            api.notesUrl(ID)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @IBOutlet weak var notesView: UITableView!
    
    lazy var api : DictController = DictController(delegate: self)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell") as UITableViewCell
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.body
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var note = notes[indexPath.row]
    }
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSDictionary = results as NSDictionary
        dispatch_async(dispatch_get_main_queue(), {
            self.notes = Note.notesWithJSON(resultsArr)
            self.notesView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    @IBAction func noteSend(sender: UIButton) {
        
        var docid:NSString = documentId.text!
        var notetext:NSString = noteText.text
        var user:NSString = userId.text!
        var post:NSString = "note[body]=\(notetext)&note[document_id]=\(docid)&note[user_id]=\(user)"
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string:"http://178.62.204.157/notes")!

        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String( postData.length )
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")    
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)

        var id = docId.toInt()
        api.notesUrl(id!)
    }
}


