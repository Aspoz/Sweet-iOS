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
    var backend = Backend()
    
    init(delegate: ArrayControllerProtocol) {
        self.delegate = delegate
    }

    func get(path: String, getSuccess: () -> Void) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        var token = backend.userToken()
        request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
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
            getSuccess()
        })
        task.resume()
    }
    
    func getAllCases(success: () -> Void) -> Void {
        let urlPath = backend.BASE_URL + "/cases"
        get(urlPath, getSuccess: { () -> Void in
            success()
        })
    }
}
