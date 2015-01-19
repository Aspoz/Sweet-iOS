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
        println("init delegate")
    }
    
    func getAllCases(success: () -> Void, error: () -> Void) -> Void {
        backend.get("/cases", getSuccess: { (data) -> Void in
            self.delegate.didReceiveAPIResults(data as NSArray)
            success()
        }) { () -> Void in
            error()
        }
        
    }
}
