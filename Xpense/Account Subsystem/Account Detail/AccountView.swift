//
//  AccountView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - AccountsView
/// Detail view for a single `Account` including all its transactions
struct AccountView: View {
    /// The `Model` the   `Account` shall be read from
    @EnvironmentObject private var model: Model
    
    /// Indicates whether the edit account sheet is supposed to be presented
    @State private var edit = false
    
    /// The `Account`'s identifier that should be displayed
    var id: Account.ID
    
    
    var body: some View {
        AccountSummary(id: id)
            .sheet(isPresented: $edit) {
                EditAccount(model, id: self.id)
            }
            .toolbar {
                Button(action: { self.edit = true }) {
                    Text("Edit")
                }
            }
    }
}


// MARK: - AccountView Previews
struct AccountView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    
    static var previews: some View {
        NavigationStack {
            AccountView(id: model.accounts[0].id)
        }.environmentObject(model)
    }
}
