//
//  DocumentViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 30-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {
    
    @IBOutlet weak var PdfView: UIWebView!
    var document: Document?

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.document != nil {
            var id = self.document!.id
            var title = self.document!.title
            var attachment_url = self.document!.attachment_url
            singleDocumentUrl(attachment_url)
        }
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
        var id = self.document!.id
        var title = self.document!.title
        if (segue.identifier == "noteSegue") {
            var svc = segue.destinationViewController as NoteViewController;
            svc.ID = id
            let x : Int = id
            var myString = String(x)
            
            svc.toPass = myString
            svc.docTitle = title
        }
    }
}