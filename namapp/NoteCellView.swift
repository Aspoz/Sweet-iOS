//
//  NoteCellView.swift
//  namapp
//
//  Created by Jordi Wippert on 27-01-15.
//  Copyright (c) 2015 Jordi Wippert. All rights reserved.
//

import UIKit

// class NoteCell for the NoteViewController for each cell
class NoteCell: UITableViewCell {
    
    // Set cell variables
    @IBOutlet weak var NoteBody: UILabel!

    func height() -> CGFloat {
        NoteBody.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        NoteBody.sizeToFit()
        if NoteBody.frame.height < 50{
            println(NoteBody.frame.height)
            return 70
        } else {
            println(NoteBody.frame.height)
            return NoteBody.frame.height * 1.7
        }
    }

    // Fill in Prototype cells for Case Overview with data
    func addDataInCellsForNote(note: Note) {
        NoteBody.text = note.body
    }
}
