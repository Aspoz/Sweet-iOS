//
//  ApiController.swift
//  namapp
//
//  Created by Jordi Wippert on 28-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

protocol ArrayControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class ArrayController {
    var delegate: ArrayControllerProtocol
    init(delegate: ArrayControllerProtocol) {
        self.delegate = delegate
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSArray
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult as NSArray
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        task.resume()
    }
    
    func meetingsUrl() {
        let urlPath = "http://178.62.204.157/api/"
        get(urlPath)
    }
}