//
//  NoteViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 03-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class NoteViewController: ApplicationViewController, DictControllerProtocol, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate{
    var document: Document?
    var notes = [Note]()
    
    var docId:String!
    var ID:Int!
    var docTitle:String!
    var userId:String!
    
    @IBOutlet weak var noteText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
            let user_idint:Int = prefs.integerForKey("USER_ID") as Int
            userId = String(user_idint)
            api.notesUrl(ID)
        
        noteText.delegate = self

        if (noteText.text == "") {
            textViewDidEndEditing(noteText)
        }
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var note = notes.removeAtIndex(indexPath.row)
            var noteid:NSNumber = note.id
            var url:NSURL = NSURL(string:"http://0.0.0.0:3000/notes/\(noteid)")!
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "DELETE"
            var reponseError: NSError?
            var response: NSURLResponse?
            var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
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
        
        var docid:NSString = docId
        var notetext:NSString = noteText.text
        var user:NSString = userId
        var post:NSString = "note[body]=\(notetext)&note[document_id]=\(docid)&note[user_id]=\(user)"
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string:"http://0.0.0.0:3000/notes")!

        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:NSString = String( postData.length )
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Token token=9bfe788a53e51575ef246bc641c3cc6e", forHTTPHeaderField: "Authorization")
        var reponseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)

        var id = docId.toInt()
        api.notesUrl(id!)
        
        noteText.text = nil
    }
    
    
    func dismissKeyboard(){
        noteText.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (noteText.text == "") {
            noteText.text = "Start typing your note here."
            noteText.textColor = UIColor.lightGrayColor()
        }
        noteText.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (noteText.text == "Start typing your note here."){
            noteText.text = ""
            noteText.textColor = UIColor.blackColor()
        }
        noteText.becomeFirstResponder()
    }

}


