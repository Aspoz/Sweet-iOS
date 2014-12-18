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
    let spinner = LoadingSpinner.instance
    
    lazy var api : DictController = DictController(delegate: self)

    @IBOutlet weak var sideBar: UIView!
    @IBOutlet weak var PdfView: UIWebView!
    @IBOutlet weak var notesView: UITableView!
    @IBOutlet weak var noteText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.startLoadingSpinner(view)
        if self.document != nil {
            var id = self.document!.id
            var title = self.document!.title
            var attachment_url = self.document!.attachment_url
            singleDocumentUrl(attachment_url)
        }
        
        self.sideBar.hideElement()
        var id = self.document!.id
        api.notesUrl(id, success: { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                println("API Success Callback")
                self.spinner.stopLoadingSpinner()
            }
        })
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
        if self.sideBar.alpha == 1 {
            UIView.animateWithDuration(0.5, animations: {
                self.sideBar.frame = CGRect(x: 700, y: 111, width: self.sideBar.frame.width, height: self.sideBar.frame.height)
                self.sideBar.hideElement()
                self.PdfView.frame = CGRect(x: 82, y: 82, width: self.PdfView.frame.width, height: self.PdfView.frame.height)
            })
        } else {
            UIView.animateWithDuration(0.5, delay: 0, options: nil, animations: {
                self.PdfView.center = CGPoint(x: 260, y: 582)
                self.sideBar.showElement()
                self.sideBar.frame = CGRect(x: 500, y: 111, width: self.sideBar.frame.width, height: self.sideBar.frame.height)
            }, completion: nil)
        }
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
        api.notesUrl(id, success: { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                println("API Success Callback")
                self.spinner.stopLoadingSpinner()
            }
        })
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


