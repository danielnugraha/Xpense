//
//  Date+MinutesFormNow.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 3/14/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation

extension Date {
    /// Create a new date a certain amount of minutes from now.
    /// - Parameters:
    ///     - minutesFromNow: The amount of minutes the event shall be in the future.
    init(minutesFromNow minutes: Int) {
        self = Calendar.current.date(byAdding: .minute, value: minutes, to: Date()) ?? Date()
    }
}
