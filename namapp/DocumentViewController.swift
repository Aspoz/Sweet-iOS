//
//  DocumentViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 30-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class DocumentViewController: ApplicationViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, DictControllerProtocol{
    
    var document: Document?
    var notes = [Note]()
    let backend = Backend()
    
    lazy var api : DictController = DictController(delegate: self)

    @IBOutlet weak var PdfView: UIWebView!
    @IBOutlet weak var notesView: UITableView!
    @IBOutlet weak var noteText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.document != nil {
            var id = self.document!.id
            var title = self.document!.title
            var attachment_url = self.document!.attachment_url
            singleDocumentUrl(attachment_url)
        }
        
        var id = self.document!.id
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
    
    func get(path: String) {
        let attachment_url : NSURL! = NSURL(string: path)
        PdfView.loadRequest(NSURLRequest(URL: attachment_url))
    }
    
    func singleDocumentUrl(attachment_url: String) {
        get("http://\(attachment_url)")
    }

    @IBAction func showNotes(sender: UIButton) {
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        var id = self.document!.id
//        var title = self.document!.title
//        if (segue.identifier == "noteSegue") {
//            var doc = segue.destinationViewController as NoteViewController;
//            doc.id = id
//            doc.docTitle = title
//        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let note = notes[indexPath.row] as Note

        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell") as UITableViewCell
        cell.textLabel?.text = note.body
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var note = notes[indexPath.row]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            var note = notes.removeAtIndex(indexPath.row)
            var noteid:NSNumber = note.id
            backend.destroy("/notes/\(noteid)")
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
        var id = self.document!.id
        var docid:NSNumber = id
        var notetext:NSString = noteText.text
        var userid = backend.currentUser()
        backend.post("/notes", params: "note[body]=\(notetext)&note[document_id]=\(docid)&note[user_id]=\(userid)")
        api.notesUrl(id)
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


