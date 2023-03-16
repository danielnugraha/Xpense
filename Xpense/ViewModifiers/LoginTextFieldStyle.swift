//
//  LoginTextFieldStyle.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI


// MARK: LoginTextFieldStyle
/// A `TextFieldStyle` that adds styles the textfiled with a `secondarySystemBackground` colored background
/// and a small border around the text
struct LoginTextFieldStyle: TextFieldStyle {
    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textContentType(.password)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("BackgroundColor").opacity(0.6))
            )
    }
}
