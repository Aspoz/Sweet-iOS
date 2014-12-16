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
    
    func completion(data: NSData!, response: NSURLResponse!, error: NSError!) -> Void {
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
    }

    func get(path: String) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        request.setValue("Token token=5a84c78af6b01d2a0445f51dffded103", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            println(data)
            if (error != nil) {
                println("henk")
                
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
    
       func casesUrl() {
        let urlPath = "http://0.0.0.0:3000/cases"
        get(urlPath)
    }
}
