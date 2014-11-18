//
//  Meeting.swift
//  namapp
//
//  Created by Jordi Wippert on 29-10-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

class Meeting {
    var id: Int
    var title: String
    var url: String
    
    init(id: Int, title: String, url: String) {
        self.id = id
        self.title = title
        self.url = url
    }
    
    class func meetingsWithJSON(allResults: NSArray) -> [Meeting] {
        var meetings = [Meeting]()
        if allResults.count>0 {
            for result in allResults {
                var id = result["id"] as? Int
                var title = result["title"] as? String
                var url = result["url"] as? String
                var newMeeting = Meeting(id: id!, title: title!, url: url!)
                meetings.append(newMeeting)
            }
        }
        return meetings
    }
}