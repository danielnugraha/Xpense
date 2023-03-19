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
    
    @State private var selectedTab = 1
    /// Indicates whether the alert asking to confirm the logout process should be displayed
    @State private var presentUserAlert = false
    /// Indicates whether the add transaction sheet is supposed to be presented
    @State private var presentSheet = false
    
    
    var body: some View {
        NavigationStack(path: $model.path) {
            if model.user == nil {
                LoginView(model)
            } else {
                TabView(selection: $selectedTab) {
                    AccountsOverview()
                    TransactionsOverview()
                    
                }
                .navigationTitle(selectedTab == 1 ? "Accounts" : "Transactions")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        UserButton(presentUserAlert: $presentUserAlert)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        addButton
                    }
                }
                .alert(isPresented: $presentUserAlert) {
                    UserButton.createLogoutAlert(model)
                }
                .sheet(isPresented: $presentSheet) {
                    if selectedTab == 1 {
                        EditAccount(model, id: nil)
                    } else {
                        EditTransaction(self.model, id: nil)
                    }
                }
                .navigationDestination(for: XpenseModel.Account.self) { account in
                    AccountView(id: account.id)
                }
                .navigationDestination(for: XpenseModel.Transaction.self) { transaction in
                    TransactionView(id: transaction.id)
                }
            }
        }
    }
    
    /// Button that is used to add a new `Transaction`
    private var addButton: some View {
        Button(action: { self.presentSheet = true }) {
            Image(systemName: "plus")
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
