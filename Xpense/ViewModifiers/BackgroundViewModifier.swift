//
//  BackgroundViewModifier.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI


// MARK: - BackgroundViewModifier
/// A `ViewModifier` to style a `View` with a system background color
private struct BackgroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
            )
    }
}


// MARK: - View + BackgroundViewModifier
extension View {
    /// Style a `View` with a grouped system background color
    /// - Returns: A view with the applied background
    func backgroundViewModifier() -> some View {
        ModifiedContent(content: self, modifier: BackgroundViewModifier())
    }
}
