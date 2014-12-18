//
//  FormatDate.swift
//  namapp
//
//  Created by Boyd Dames on 18-12-14.
//  Copyright (c) 2014 Jordi Wippert. All rights reserved.
//

import UIKit

extension String {
    
    func turnDateIntoString(dateString: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let date = formatter.dateFromString(dateString)
        return date!
    }
    
    func formatDate() -> String {
        var dateObj = turnDateIntoString(self)
        let formatter = NSDateFormatter()
        // %H:%M - %-d %b %Y
        formatter.dateFormat = "HH:mm' - 'dd MMM yyyy"
        
        let returnDate = formatter.stringFromDate(dateObj)
        return returnDate
    }
    
}
