//
//  TransactionSummary.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 13/03/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - TransactionSummary
/// Displays the information about a `Transaction` including all its information
struct TransactionSummary: View {
    /// The `Model` the   `Transaction` shall be read from
    @EnvironmentObject private var model: Model
    
    /// The `Transaction`'s identifier that should be displayed
    var id: XpenseModel.Transaction.ID
    
    @Binding var path: [ContentLink]
    
    
    var body: some View {
        model.transaction(id).map { transaction in
            VStack(spacing: 5) {
                Spacer()
                    .frame(height: 15)
                Text(transaction.amountDescription)
                    .currencyViewModifier(size: 60, weight: .semibold)
                
                Group {
                    Text(transaction.description)
                    Text(transaction.dateDescription)
                }.foregroundColor(.secondary)
                
                AccountDetailLink(path: $path, id: transaction.account)
                
                transaction.location?.clCoordinate.map { coordinate in
                    LocationDetailLink(coordinate: coordinate,
                                       navigationTitle: transaction.description)
                }
            }
            .backgroundViewModifier()
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// MARK: - TransactionSummary Previews
struct TransactionSummary_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    @State static var path: [ContentLink] = []
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            NavigationStack {
                TransactionSummary(id: model.transactions[0].id, path: $path)
            }.colorScheme(colorScheme)
        }.background(Color("BackgroundColor"))
            .environmentObject(model)
    }
}
