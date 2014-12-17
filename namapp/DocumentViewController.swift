//
//  DocumentViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 30-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

@objc
protocol DocumentViewControllerDelegate {
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class DocumentViewController: ApplicationViewController, NoteViewControllerDelegate {
    
    var delegate: DocumentViewControllerDelegate?

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
        delegate?.toggleRightPanel?()
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        var id = self.document!.id
//        var title = self.document!.title
//        if (segue.identifier == "noteSegue") {
//            var doc = segue.destinationViewController as NoteViewController;
//            doc.id = id
//            doc.docTitle = title
//        }
//    }
    
}
