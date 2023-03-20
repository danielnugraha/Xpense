//
//  AccountView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 13/03/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
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
    
    @ObservedObject var contentState: ContentState
    
    /// The `Account`'s identifier that should be displayed
    var id: Account.ID
    
    
    var body: some View {
        AccountSummary(id: id, path: $contentState.path)
            .toolbar {
                Button(action: { self.contentState.presentedItem = .accountLink(id: self.id) }) {
                    Text("Edit")
                }
            }
    }
}


// MARK: - AccountView Previews
struct AccountView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    @State static var path = ContentState()
    static var previews: some View {
        NavigationStack {
            AccountView(contentState: path, id: model.accounts[0].id)
        }.environmentObject(model)
    }
}
