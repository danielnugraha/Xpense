//
//  NumberFormatter+Cent.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation


extension NumberFormatter {
    /// Converts a cent-value to a readable currency value. The currency symbol is added depending on your locale.
    ///
    /// Example: 152345 -> $1,52
    public static let currencyAmount: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.multiplier = 0.01
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    /// Converts an amount of cents into it's corresponding currency representation.
    /// We use this method to minimize the number of times in our code where we convert a Double to an NSNumber.
    ///
    /// Example: 152345 -> $1,52
    /// - Parameters:
    ///    - cent: The amount in cents
    /// - Returns: The amount converted into its currency representation if the conversion succeeded, otherwise nil
    public static func currencyRepresentation(from cent: Transaction.Cent) -> String? {
        currencyAmount.string(from: NSNumber(value: Double(cent)))
    }
}
