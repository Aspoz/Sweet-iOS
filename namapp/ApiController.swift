//
//  ApiController.swift
//  namapp
//
//  Created by Jordi Wippert on 28-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSDictionary)
}

class APIController {
    var delegate: APIControllerProtocol
    init(delegate: APIControllerProtocol) {
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
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            if(err != nil) {
                println("JSON Error \(err!.localizedDescription)")
            }
            let results: NSDictionary = jsonResult as NSDictionary
            self.delegate.didReceiveAPIResults(jsonResult)
        })
        task.resume()
    }
    
    func subjectsUrl(id: Int) {
        get("http://178.62.204.157/api/subjecttypes/\(id)")
    }
    
    func documentsUrl(subjectId: Int) {
        get("http://10.0.0.86:3000/meetings/\(subjectId)")
    }
    
}