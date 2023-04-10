//
//  TransactionView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 11/03/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - TransactionView
/// Detail view for a single `Transaction` including all its information
struct TransactionView: View {
    /// The `Model` the   `Transaction` shall be read from
    @EnvironmentObject private var model: Model
    @Environment(\.isPresented) var isPresented
    
    /// Indicates whether the edit transaction sheet is supposed to be presented
    @State private var edit = false
    
    @ObservedObject var contentState: ContentState
    
    /// The `Transaction`'s identifier that should be displayed
    var id: XpenseModel.Transaction.ID
    
    
    var body: some View {
        TransactionSummary(id: id, path: $contentState.path)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { self.contentState.presentedItem = .transactionLink(id: self.id) }) {
                        Text("Edit")
                    }.disabled(model.transactions.isEmpty)
                }
            }
    }
}


// MARK: - TransactionView Previews
struct TransactionView_Previews: PreviewProvider {
    private static let mock: Model = MockModel()
    @StateObject static var path = ContentState()
    
    static var previews: some View {
        NavigationStack {
            TransactionView(contentState: path, id: mock.transactions[0].id)
        }.environmentObject(mock)
    }
}
