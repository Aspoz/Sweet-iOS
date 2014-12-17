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
    
    let backend = Backend()

    var id:Int!
    var docTitle:String!
    var userId:String!
    
    @IBOutlet weak var noteText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        api.notesUrl(id)
        
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
            backend.delete("/notes/\(noteid)", params: "")
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
        var docid:NSNumber = id
        var notetext:NSString = noteText.text
        var userid = backend.currentUser()
        backend.post("/notes", params: "note[body]=\(notetext)&note[document_id]=\(docid)&note[user_id]=\(userid)")
        api.notesUrl(id!)
        noteText.text = nil
    }
    
    func dismissKeyboard(){
        noteText.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.addPlaceholderIfEmpty("Enter your note here...")
        noteText.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        textView.addPlaceholderIfEmpty("Enter your note here...")
        noteText.becomeFirstResponder()
    }
}


