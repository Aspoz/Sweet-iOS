//
//  Document.swift
//  namapp
//
//  Created by Jordi Wippert on 25-11-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

class Document {
    var id: Int
    var title: String
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    class func documentsWithJSON(allResults: NSDictionary) -> [Document] {
        var documents = [Document]()
        if allResults.count>0 {
            if let links = allResults["_links"] as? NSDictionary {
                if let allDocuments = links["documents"] as? NSArray {
                    for document in allDocuments {
                        var id = document["id"] as Int
                        var title = document["title"] as? String
                        var document = Document(id: id, title: title!)
                        documents.append(document)
                    }
                }
            }
        }
        return documents
    }
}
