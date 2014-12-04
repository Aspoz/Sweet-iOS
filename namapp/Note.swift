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
    
    init(id: Int, body: String) {
        self.id = id
        self.body = body
    }
    
    class func notesWithJSON(allResults: NSDictionary) -> [Note] {
        var notes = [Note]()
        if allResults.count>0 {
            if let links = allResults["_links"] as? NSDictionary {
                if let allNotes = links["notes"] as? NSArray {
                    for note in allNotes {
                        var id = note["id"] as Int
                        var body = note["body"] as? String
                        var note = Note(id: id, body: body!)
                        notes.append(note)
                    }
                }
            }
        }
        return notes
    }
}
