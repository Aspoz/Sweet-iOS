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
        get("http://178.62.204.157/cases/\(id)")
    }
}