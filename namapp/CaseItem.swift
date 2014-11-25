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
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    class func casesWithJSON(allResults: NSArray) -> [CaseItem] {
        var cases = [CaseItem]()
        if allResults.count>0 {
            for result in allResults {
                var id = result["id"] as? Int
                var title = result["title"] as? String
                var newCase = CaseItem(id: id!, title: title!)
                cases.append(newCase)
            }
        }
        return cases
    }
}