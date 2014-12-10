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
    var user_id: Int
    
    init(id: Int, body: String, user_id: Int) {
        self.id = id
        self.body = body
        self.user_id = user_id
    }
    
    class func commentsWithJSON(allResults: NSDictionary) -> [Comment] {
        var comments = [Comment]()
        if allResults.count>0 {
            if let links = allResults["_links"] as? NSDictionary {
                if let allComments = links["comments"] as? NSArray {
                    for comment in allComments {
                        var id = comment["id"] as Int
                        var body = comment["body"] as? String
                        var user_id = comment["user_id"] as Int
                        var comment = Comment(id: id, body: body!, user_id: user_id)
                        comments.append(comment)
                    }
                }
            }
        }
        return comments
    }
}