//
//  Note.swift
//  namapp
//
//  Created by Jordi Wippert on 03-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import Foundation

class Note {
    var id: Int
    var body: String
    var user_id: Int
    
    init(id: Int, body: String, user_id: Int) {
        self.id = id
        self.body = body
        self.user_id = user_id
    }
    
    class func notesWithJSON(allResults: NSDictionary) -> [Note] {
        var notes = [Note]()
        if allResults.count>0 {
            if let links = allResults["_links"] as? NSDictionary {
                if let allNotes = links["notes"] as? NSArray {
                    for note in allNotes {
                        var id = note["id"] as Int
                        var body = note["body"] as? String
                        var user_id = note["user_id"] as Int
                        var note = Note(id: id, body: body!, user_id: user_id)
                        if note.user_id == Backend().currentUser() {
                        notes.append(note)
                        }
                    }
                }
            }
        }
        return notes
    }
}
