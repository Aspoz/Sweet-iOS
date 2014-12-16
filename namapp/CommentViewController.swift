//
//  CommentViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 08-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class CommentViewController: ApplicationViewController, DictControllerProtocol, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    var id:Int!
    
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var commentTableView: UITableView!
    
    let backend = Backend()

    var caseitem: CaseItem?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var id = caseitem!.id
//        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
//        let user_idint:Int = prefs.integerForKey("USER_ID") as Int
//        user_id = String(user_idint)
        
        commentText.delegate = self
        
        if (commentText.text == "") {
            textViewDidEndEditing(commentText)
        }
        
        commentText!.layer.borderWidth = 1
        commentText!.layer.borderColor = UIColor.colorWithRGBHex(0x4A90E2).CGColor
        commentText.applyPlainShadow()
        
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
        api.documentsUrl(id)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.commentTableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    lazy var api : DictController = DictController(delegate: self)
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as CommentCell
        let comment = comments[indexPath.row]
        cell.addDataInCellsForComment(comment)
        
        if(comments.count > 0) {
            if(indexPath.row == (comments.count-1)) {
                // if it's the last cell, add shadow
                cell.applyPlainShadow()
            } else {
                cell.removeShadow()
            }
        }

        return cell
    }
    
    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var comment = comments[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as CommentCell
        cell.addDataInCellsForComment(comment)
        println(cell.height())
        return cell.height()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var comment = comments[indexPath.row]
    }
    
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArr: NSDictionary = results as NSDictionary
        dispatch_async(dispatch_get_main_queue(), {
            self.comments = Comment.commentsWithJSON(resultsArr)
            self.commentTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if comments.count != 0 {
                var comment = comments.removeAtIndex(indexPath.row)
                var commentid:NSNumber = comment.id
                var url:NSURL = NSURL(string:"http://178.62.204.157/comments/\(commentid)")!
                var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "DELETE"
                var reponseError: NSError?
                var response: NSURLResponse?
                var urlData: NSData? = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&reponseError)
                
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    @IBAction func commentSend(sender: UIButton) {
        var caseid:Int = caseitem!.id
        var commenttext:NSString = commentText.text
        var userid = backend.currentUser()
        backend.request("/comments", params: "comment[body]=\(commenttext)&comment[subject_id]=\(caseid)&comment[user_id]=\(userid)", method: "POST")
        api.documentsUrl(caseid)
        commentText.text = nil
    }
    
    func dismissKeyboard(){
        commentText.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        textView.addPlaceholderIfEmpty("Enter your comment here...")
        commentText.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        textView.addPlaceholderIfEmpty("Enter your comment here...")
        commentText.becomeFirstResponder()
    }
}
