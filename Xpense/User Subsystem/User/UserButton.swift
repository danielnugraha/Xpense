//
//  UserButton.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - UserButton
/// Button that is used to show information about the current `User`
struct UserButton: View {
    /// The `Model` the   `User` shall be read from
    @EnvironmentObject private var model: Model
    
    /// Indicates whether the alert asking to confirm the logout process should be displayed
    @Binding var presentUserAlert: Bool
    
    
    var body: some View {
        Button(action: { self.presentUserAlert = true }) {
            Image(systemName: "person.circle")
        }
            .alert(isPresented: $presentUserAlert) {
                UserButton.createLogoutAlert(model)
            }
    }
    
    
    /// Creates the alert asking to confirm the logout process
    /// - Parameter model: The model used for the logout process
    static func createLogoutAlert(_ model: Model) -> Alert {
        let alertText: String = "You are logged in as \"\(model.user?.name ?? "")\""
        return Alert(title: Text("User Overview"),
                     message: Text(alertText),
                     primaryButton: .destructive(Text("Logout"), action: model.logout),
                     secondaryButton: .default(Text("OK")))
    }
}


// MARK: - UserButton Previews
struct UserButton_Previews: PreviewProvider {
    @State private static var presentUserAlert = false
    
    
    static var previews: some View {
        UserButton(presentUserAlert: $presentUserAlert)
    }
}
