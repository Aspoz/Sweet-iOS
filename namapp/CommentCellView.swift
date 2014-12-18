//
//  CommentCellView.swift
//  namapp
//
//  Created by Boyd Dames on 15-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

// class CommentCell for the CommentViewController for each cell
class CommentCell: UITableViewCell {
    
    // Set cell variables
    @IBOutlet weak var CommentBody: UILabel!
    @IBOutlet weak var CommentAuthor: UILabel!
    @IBOutlet weak var CommentDate: UILabel!
    
    func height() -> CGFloat {
        CommentBody.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        CommentBody.sizeToFit()
        if CommentBody.frame.height < 50 {
            return 70
        } else {
            return CommentBody.frame.height * 1.7
        }
    }
    
    // Fill in Prototype cells for Case Overview with data
    func addDataInCellsForComment(comment: Comment) {
        CommentBody.text = comment.body
        CommentAuthor.text = comment.user_name
        CommentDate.text = comment.created_at.formatDate()
    }
}
