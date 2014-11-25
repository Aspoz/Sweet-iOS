//
//  DocumentViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 30-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit
import Alamofire

class DocumentViewController: UIViewController {
    @IBOutlet weak var PdfView: UIWebView!
    var document: Document?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url : NSURL! = NSURL(string: "http://178.62.204.157/system/documents/attachments/000/000/033/original/PDF_File_small.pdf")
        PdfView.loadRequest(NSURLRequest(URL: url))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}