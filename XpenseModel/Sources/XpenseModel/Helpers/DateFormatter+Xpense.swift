//
//  DateFormatter+Xpense.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation

extension DateFormatter {
    /// Formatter that includes the date as well as the time.
    ///
    /// Example: September 3, 2018 at 3:38 PM
    public static let dateAndTime: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    /// Formatter that includes only the date.
    ///
    /// Example: 9/3/18
    public static let onlyDate: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
}
