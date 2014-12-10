//
//  Comment.swift
//  namapp
//
//  Created by Jordi Wippert on 08-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

class Comment {
    var id: Int
    var body: String
    var user_name: String
    
    init(id: Int, body: String, user_name: String) {
        self.id = id
        self.body = body
        self.user_name = user_name
    }
    
    class func commentsWithJSON(allResults: NSDictionary) -> [Comment] {
        var comments = [Comment]()
        if allResults.count>0 {
            if let links = allResults["_links"] as? NSDictionary {
                if let allComments = links["comments"] as? NSArray {
                    for comment in allComments {
                        var id = comment["id"] as Int
                        var body = comment["body"] as? String
                        var user_name = comment["user_name"] as String
                        var comment = Comment(id: id, body: body!, user_name: user_name)
                        comments.append(comment)
                    }
                }
            }
        }
        return comments
    }
}