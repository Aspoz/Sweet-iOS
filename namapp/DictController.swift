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

    init(delegate: DictControllerProtocol) {
        self.delegate = delegate
    }
    
    func caseUrl(id: Int, success: () -> Void, error: () -> Void) {
        backend.get("/cases/\(id)", getSuccess: { (data) -> Void in
            self.delegate.didReceiveAPIResults(data as NSDictionary)
            success()
        }) { (err) -> Void in
            println(err)
            error()
        }
    }
    
    func notesUrl(id: Int, success: () -> Void, error: () -> Void) {
        backend.get("/documents/\(id)", getSuccess: { (data) -> Void in
            self.delegate.didReceiveAPIResults(data as NSDictionary)
            success()
        }) { (err) -> Void in
            error()
        }
    }
}