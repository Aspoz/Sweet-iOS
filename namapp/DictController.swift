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
    let backend = Backend()
    let baseURL = Backend().BASE_URL

    init(delegate: DictControllerProtocol) {
        self.delegate = delegate
    }

    func get(path: String, getSuccess: () -> Void) {
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        var token = backend.userToken()
        request.setValue("Token token=\(token)", forHTTPHeaderField: "Authorization")
        let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
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
            getSuccess()
        })
        task.resume()
    }
    
    func caseUrl(id: Int, success: () -> Void) {
        let url = baseURL + "/cases/\(id)"
        get(url, getSuccess: { () -> Void in
            success()
        })
    }
    
    func notesUrl(id: Int, success: () -> Void) {
        let url = baseURL + "/documents/\(id)"
        get(url, getSuccess: { () -> Void in
            success()
        })
    }
}