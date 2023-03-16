//
//  RelativeDateTimeFormatter.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


extension RelativeDateTimeFormatter {
    /// Gives a relative date description.
    ///
    /// Example: 45 minutes ago
    static var namedAndSpelledOut: RelativeDateTimeFormatter {
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateTimeFormatter.dateTimeStyle = .named
        relativeDateTimeFormatter.unitsStyle = .full
        return relativeDateTimeFormatter
    }
}
