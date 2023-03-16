//
//  LoginButtons.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/8/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - LoginButtons
/// The buttons that display the primary and secondary buttons for the login screen
struct LoginButtons: View {
    /// The `LoginViewModel` that manages the content of the login screen
    @ObservedObject var viewModel: LoginViewModel
    
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: viewModel.primaryAction) {
                Text(viewModel.state.primaryActionTitle)
            }.buttonStyle(PrimaryButtonStyle(animating: $viewModel.loadingInProcess))
                .disabled(!viewModel.calculateEnablePrimaryButton)
            Spacer()
                .frame(height: 16)
            Button(action: viewModel.secondaryAction) {
                Text(viewModel.state.secondaryActionTitle)
            }
        }
    }
}


// MARK: - LoginButtons Previews
struct LoginButtons_Previews: PreviewProvider {
    static var previews: some View {
        LoginButtons(viewModel: LoginViewModel(MockModel()))
    }
}
