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
            var url = self.document!.url
            singleDocumentUrl(url)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func get(path: String) {
        let url : NSURL! = NSURL(string: path)
        PdfView.loadRequest(NSURLRequest(URL: url))
        println(url)
    }
    
    func singleDocumentUrl(url: String) {
        get("\(url)")
    }
}



