//
//  CaseItem.swift
//  namapp
//
//  Created by Jordi Wippert on 24-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

class CaseItem {
    var id: Int
    var title: String
    var casetype: String
    var status: String
    
    init(id: Int, title: String, casetype: String, status: String) {
        self.id = id
        self.title = title
        self.casetype = casetype
        self.status = status
    }
    
    class func casesWithJSON(allResults: NSArray) -> [CaseItem] {
        println("func casesWithJSON")
        var cases = [CaseItem]()
        if allResults.count>0 {
            for result in allResults {
                var id = result["id"] as? Int
                var title = result["title"] as? String
                var casetype = result["casetype"] as? String
                var status = result["status"] as? String
                var newCase = CaseItem(id: id!, title: title!, casetype: casetype!, status: status!)
                println("append cases")
                cases.append(newCase)
            }
        }
        return cases
    }
}