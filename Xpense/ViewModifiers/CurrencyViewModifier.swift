//
//  CurrencyViewModifier.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - CurrencyViewModifier
/// A `ViewModifier` to style a `Text` in the common Xpense currency style
private struct CurrencyViewModifier: ViewModifier {
    /// The default values for the `CurrencyViewModifier`
    fileprivate enum Defaults {
        /// The default font weight for the `CurrencyViewModifier`
        static let weight: Font.Weight = .regular
    }
    
    
    /// The size of the currency text
    let size: CGFloat
    /// The weight of the currency text
    let weight: Font.Weight
    /// The classification of the currency to style the color of the text
    let classification: XpenseModel.Transaction.Classification?
    
    
    /// - Parameters:
    ///   - size: The size of the currency text
    ///   - weight: The weight of the currency text
    ///   - classification: The classification of the currency to style the color of the text
    fileprivate init(size: CGFloat,
                     weight: Font.Weight = Defaults.weight,
                     classification: XpenseModel.Transaction.Classification? = nil) {
        self.size = size
        self.weight = weight
        self.classification = classification
    }
    
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight, design: .rounded))
            .foregroundColor(classification?.color ?? .primary)
    }
}


// MARK: - Text + CurrencyViewModifier
extension Text {
    /// Style a `Text` in the common Xpense currency style
    /// - Parameters:
    ///   - size: The size of the currency text
    ///   - weight: The weight of the currency text
    ///   - classification: The classification of the currency to style the color of the text
    /// - Returns: A view that uses the styling you specify
    func currencyViewModifier(size: CGFloat,
                              weight: Font.Weight = CurrencyViewModifier.Defaults.weight,
                              classification: XpenseModel.Transaction.Classification? = nil) -> some View {
        ModifiedContent(content: self,
                        modifier: CurrencyViewModifier(size: size,
                                                       weight: weight,
                                                       classification: classification))
    }
}
