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
    var attachment_url: String
    
    init(id: Int, title: String, attachment_url: String) {
        self.id = id
        self.title = title
        self.attachment_url = attachment_url
    }
    
    class func documentsWithJSON(allResults: NSDictionary) -> [Document] {
        var documents = [Document]()
        if allResults.count>0 {
            if let links = allResults["_links"] as? NSDictionary {
                if let allDocuments = links["documents"] as? NSArray {
                    for document in allDocuments {
                        var id = document["id"] as Int
                        var title = document["title"] as? String
                        var attachment_url = document["attachment_url"] as? String
                        var document = Document(id: id, title: title!, attachment_url: attachment_url!)
                        documents.append(document)
                    }
                }
            }
        }
        return documents
    }
}
