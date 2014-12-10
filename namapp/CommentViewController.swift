//
//  CommentViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 08-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, DictControllerProtocol, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    var id:Int!

    @IBOutlet weak var commentText: UITextView!
    
    var caseitem: CaseItem?
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var id = caseitem!.id
        commentText.delegate = self
       
        if (commentText.text == "") {
            textViewDidEndEditing(commentText)
        }
        
        commentText!.layer.borderWidth = 1
        commentText!.layer.borderColor = UIColor.colorWithRGBHex(0x4A90E2).CGColor
        
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
    
    @IBOutlet weak var commentTableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell") as UITableViewCell
        let comment = comments[indexPath.row]
        cell.textLabel?.text = comment.body
        return cell
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
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let user_idint:Int = prefs.integerForKey("USER_ID") as Int
        var user_id = String(user_idint)
        
        var caseid:NSNumber = caseitem!.id
        var commenttext:NSString = commentText.text
        var user:NSString = user_id
        var post:NSString = "comment[body]=\(commenttext)&comment[subject_id]=\(caseid)&comment[user_id]=\(user)"
        NSLog("PostData: %@",post);
        var url:NSURL = NSURL(string:"http://178.62.204.157/comments")!
        
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
        
        var id = caseitem!.id
        api.documentsUrl(id)
        
        commentText.text = nil
    }
    
    func dismissKeyboard(){
        commentText.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (commentText.text == "") {
            commentText.text = "Placeholder"
            commentText.textColor = UIColor.lightGrayColor()
        }
        commentText.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (commentText.text == "Placeholder"){
            commentText.text = ""
            commentText.textColor = UIColor.blackColor()
        }
        commentText.becomeFirstResponder()
    }

}