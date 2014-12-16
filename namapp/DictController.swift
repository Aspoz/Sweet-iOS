//
//  DictController.swift
//  namapp
//
//  Created by Jordi Wippert on 24-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

protocol DictControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class DictController {
    var delegate: DictControllerProtocol
    init(delegate: DictControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.setValue("Token token=5a84c78af6b01d2a0445f51dffded103", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSDictionary = jsonResult as NSDictionary
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        task.resume()
    }
    
    func documentsUrl(id: Int) {
        get("http://0.0.0.0:3000/\(id)")
    }
    
    func notesUrl(id: Int) {
        get("http://0.0.0.0:3000/documents/\(id)")
    }
}