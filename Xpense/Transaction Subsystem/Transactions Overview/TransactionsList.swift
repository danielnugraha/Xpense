//
//  TransactionsList.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 20/03/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel

 
// MARK: - TransactionsList
/// A list of all `Transaction`s in the Xpense Application with an option to filter the `Transaction`s using the `filter` property
struct TransactionsList: View {
    /// The model to read the transactions from
    @EnvironmentObject private var model: Model
    
    @Binding var path: [ContentLink]
    
    /// A filter function that is used to filter the `Transaction`s in the Xpense Application that should be displayed in the `TransactionsList`
    var filter: (XpenseModel.Transaction) -> Bool = { _ in true }
    
    
    /// The Transaction that are displayed in the TransactionsList
    private var transactions: [XpenseModel.Transaction] {
        model.transactions.filter(filter)
    }
    
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                Button(action: { path.append(.transactionLink(id: transaction.id)) }) {
                    TransactionCell(id: transaction.id)
                }
            }.onDelete(perform: delete(at:))
        }
    }
    
    
    /// Deletes the Transaction at the given index set in the TransactionsList
    /// - Parameters:
    ///     - indexSet: The index set of the View in the `TransactionsList` that should be deleted
    private func delete(at indexSet: IndexSet) {
        indexSet
            .map { transactions[$0].id }
            .forEach { transaction in
                Task {
                    await self.model.delete(transaction: transaction)
                    let deletedInPath = self.path.contains { contentLink in
                        switch contentLink {
                        case .transactionLink(let id):
                            return id == transaction
                        default:
                            return false
                        }
                    }
                    if deletedInPath {
                        self.path = []
                    }
                }
            }
    }
}


// MARK: - TransactionsList Previews
struct TransactionsList_Previews: PreviewProvider {
    @State static var path: [ContentLink] = []
    static var previews: some View {
        NavigationStack {
            TransactionsList(path: $path)
                .navigationTitle("Transactions")
        }.environmentObject(MockModel() as Model)
    }
}
