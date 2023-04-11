//
//  MainView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 10/03/23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel

// MARK: - MainView
/// The entry-point of the app.
struct MainView: View {
    // The `Model` the   `User` shall be read from
    @EnvironmentObject private var model: Model
    
    var body: some View {
        if model.user == nil {
            LoginView(model)
        } else {
            TabView {
                AccountsOverview()
                TransactionsOverview()
            }
        }
    }
}

// MARK: - MainView Previews
struct MainView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    
    static var previews: some View {
        MainView()
            .environmentObject(model)
    }
}
