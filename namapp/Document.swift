//
//  Document.swift
//  namapp
//
//  Created by Jordi Wippert on 28-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

class Document {
    var title: String?
    var type: String?
    var size: String?
    var url: String?

    
    init(title: String!, type: String!, size: String!, url: String!) {
        self.title = title
        self.type = type
        self.size = size
        self.url = url
    }
}

