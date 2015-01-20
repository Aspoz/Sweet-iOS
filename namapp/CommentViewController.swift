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
    let spinner = LoadingSpinner()

    var caseitem: CaseItem?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var id = caseitem!.id
        self.spinner.startLoadingSpinner(view)
        
        commentText.delegate = self
        
        if (commentText.text == "") {
            textViewDidEndEditing(commentText)
        }
        
        commentText!.layer.borderWidth = 1
        commentText!.layer.borderColor = UIColor.colorWithRGBHex(0x4A90E2).CGColor
        commentText.applyPlainShadow()
        
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
        api.caseUrl(id, success: { () -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                println("API Success Callback")
                self.spinner.stopLoadingSpinner()
            }
        }, error: { (err) -> Void in
            self.backend.logout()
            self.performSegueWithIdentifier("goto_login", sender: self)
        })
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
                backend.destroy("/comments/\(commentid)")
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            }
        }
    }
    
    @IBAction func commentSend(sender: UIButton) {
        var caseid:Int = caseitem!.id
        var commenttext:NSString = commentText.text
        var userid = backend.currentUser()
        var post_params = "comment[body]=\(commenttext)&comment[subject_id]=\(caseid)&comment[user_id]=\(userid)"
        
        backend.post("/comments", params: post_params, postSuccess: { (data) -> Void in
            self.api.caseUrl(caseid, success: { () -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    println("API Success Callback")
                    self.spinner.stopLoadingSpinner()
                }
            }, error: { (err) -> Void in
                self.backend.logout()
                self.performSegueWithIdentifier("goto_login", sender: self)
            })
        }, postError: { (err) -> Void in
            println(err)
            self.backend.alert("Comment error:", message: "Could not post the comment. Please check your internet connection.", button: "OK")
        })
        
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
