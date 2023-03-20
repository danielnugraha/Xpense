//
//  LoginTextFields.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/8/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - LoginTextFields
/// The view that displays the `TextField` for the login screen
struct LoginTextFields: View {
    /// The `LoginViewModel` that manages the content of the login screen
    @ObservedObject var viewModel: LoginViewModel
    
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(LoginTextFieldStyle())
                .textInputAutocapitalization(.never)
            Spacer()
                .frame(height: 8)
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(LoginTextFieldStyle())
            if viewModel.state == .signUp {
                Spacer()
                    .frame(height: 8)
                SecureField("Repeat Password", text: $viewModel.passwordAgain)
                    .textFieldStyle(LoginTextFieldStyle())
            }
        }
    }
}


// MARK: - LoginTextFields Previews
struct LoginTextFields_Previews: PreviewProvider {
    static var previews: some View {
        LoginTextFields(viewModel: LoginViewModel(MockModel()))
    }
}
