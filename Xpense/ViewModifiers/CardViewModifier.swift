//
//  CardViewModifier.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI


// MARK: - CardViewModifier
/// A `ViewModifier` to style a `View` with a card style background
struct CardViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color("SecondaryBackgroundColor"))
            .cornerRadius(15)
    }
}


// MARK: - View + CardViewModifier
extension View {
    /// Style a `View` with a with card style background
    /// - Returns: A view with the card style background
    func cardViewModifier() -> some View {
        ModifiedContent(content: self, modifier: CardViewModifier())
    }
}
