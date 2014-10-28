//
//  DocumentViewController.swift
//  namapp
//
//  Created by Jordi Wippert on 27-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var titleTextfield: UITextField! = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class Document: NSObject {
        var title: String, userName: String, linkURL: String, imageURL: String
        
        init(title: String, userName: String, linkURL: String, imageURL: String) {
            self.title = title
            self.userName = userName
            self.linkURL = linkURL
            self.imageURL = imageURL
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
