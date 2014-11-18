//
//  Subject.swift
//  namapp
//
//  Created by Jordi Wippert on 28-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

class Subject {
    
    var id: Int
    var title: String
    var subjects = [Subject]()
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    class func subjectsWithJSON(allResults: NSDictionary) -> [Subject] {
        var subjects = [Subject]()
        if allResults.count>0 {
            if let links = allResults["_links"] as? NSDictionary {
                if let documents = links["subjects"] as? NSArray {
                    for document in documents {
                        var id = document["id"] as Int
                        var title = document["title"] as? String

                        var subject = Subject(id: id, title: title!)
                        subjects.append(subject)
                    }
                }
            }
        }
        return subjects
    }
}
