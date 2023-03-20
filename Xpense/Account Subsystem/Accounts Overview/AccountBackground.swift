//
//  AccountBackground.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/25/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI


// MARK: - AccountBackground
/// The background of an Account view drawing a rounded rectangle including a shaddow
struct AccountBackground: View {
    /// The current system `ColorScheme`
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(Color("SecondaryBackgroundColor"))
            .shadow(radius: 3)
    }
}


// MARK: - AccountBackground
struct AccountBackground_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AccountBackground()
            AccountBackground()
                .preferredColorScheme(.dark)
        }.padding()
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
