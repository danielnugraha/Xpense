//
//  LoginViewModel.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/8/20.
//  Rewritten by Daniel Nugraha on 09/03/23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: LoginViewModel
class LoginViewModel: ObservableObject {
    /// The Constants that are used to define the behaviour of the `LoginViewModel`
    enum Constants {
        /// The minimal password length that is enforced by the `LoginViewModel`
        static let minimalPasswordLength = 8
    }
    
    // State
    /// The current state of the login view defined by the `LoginState`
    @Published var state: LoginState = .login
    // Input
    /// The current username that is typed in the login view
    @Published var username: String = ""
    /// The current password that is typed in the login view
    @Published var password: String = ""
    /// The current password that is typed in the second `Textfield` in the login view
    @Published var passwordAgain: String = ""
    //Output
    /// Indicates whether the primary `Button` of the login view sould be enabled
    @Published var enablePrimaryButton = true
    /// Indicates whether the Model is currently loading data
    @Published var loadingInProcess = false
    
    /// The `Model` that is used to interact with the `User` of the Xpense application
    private weak var model: Model?
    
    
    /// Indicates whether the current typed in password is valid according to the rules defined in the `LoginViewModel`
    var validPassword: Bool {
        password.count >= Constants.minimalPasswordLength
    }
    
    /// Indicates whether the current typed in password and the password that is typed in the second `Textfield` in
    /// the login view is are the same and valid according to the rules defined in the `LoginViewModel`
    var validatedSignUpPassword: Bool {
        validPassword && password == passwordAgain
    }
    
    /// Calculates whether the primary `Button` of the login view sould be enabled
    var calculateEnablePrimaryButton: Bool {
        switch state {
        case .login:
            return !username.isEmpty && validPassword
        case .signUp:
            return !username.isEmpty && validPassword && validatedSignUpPassword
        }
    }
    
    /// - Parameter model: The `Model` that is used to interact with the `User` of the Xpense application
    init(_ model: Model) {
        self.model = model
    }
    
    
    /// The primary action of the login view. The performed action is dependet on the current state of the
    /// login view defined by the `LoginState`
    func primaryAction() {
        loadingInProcess = true
        
        Task.init {
            switch state {
            case .login:
                await model?.login(username, password: password)
            case .signUp:
                await model?.signUp(username, password: password)
            }
            
            DispatchQueue.main.async {
                self.loadingInProcess = false
            }
        }
    }
    
    /// The secondary action of the login view. The performed action is dependet on the current state of the
    /// login view defined by the `LoginState`
    func secondaryAction() {
        withAnimation(.easeInOut(duration: 0.2)) {
            state.toggle()
        }
    }
}
