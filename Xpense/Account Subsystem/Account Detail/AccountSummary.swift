//
//  AccountSummary.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - AccountsSummary
/// An overview of an existing `Account`'s balance and its `Transaction`s.
struct AccountSummary: View {
    /// The `Model` the   `Account` shall be read from
    @EnvironmentObject private var model: Model
    
    /// The `Account`'s identifier
    var id: Account.ID
    
    
    var body: some View {
        VStack {
            AccountBalanceView(id: id)
            TransactionsList() { transaction in
                transaction.account == self.id
            }
        }.navigationTitle(model.account(id)?.name ?? "")
    }
}

// MARK: - AccountSummary Previews
struct AccountSummary_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    private static var accountId = model.accounts[0].id
    
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            NavigationStack {
                AccountSummary(id: accountId)
            }.colorScheme(colorScheme)
        }.environmentObject(model)
    }
}
