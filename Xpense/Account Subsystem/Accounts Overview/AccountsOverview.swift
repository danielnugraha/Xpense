//
//  AccountsOverview.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 13/03/23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - AccountsOverview
/// An overview of all `Account`s the Xpense Application
struct AccountsOverview: View {
    var body: some View {
        ScrollView(.vertical) {
            AccountsBalance()
                .padding(.bottom, 8)
            AccountsGrid()
                .padding(.bottom, 16)
        }.backgroundViewModifier()
            .tabItem {
                Image(systemName: "rectangle.stack")
                Text("Accounts")
            }
            .tag(1)
    }
}


// MARK: - AccountsView Previews
struct AccountsView_Previews: PreviewProvider {
    static var previews: some View {
        AccountsOverview()
            .environmentObject(MockModel() as Model)
    }
}
