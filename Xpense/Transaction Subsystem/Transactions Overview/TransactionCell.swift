//
//  TransactionCell.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - TransactionCell
/// A list cell representing a single `Transaction`
struct TransactionCell: View {
    /// The model to read the transactions from
    @EnvironmentObject private var model: Model
    
    /// The `Transaction`'s identifier that should be displayed in the `TransactionCell`
    var id: XpenseModel.Transaction.ID
    
    
    var body: some View {
        model.transaction(id).map { transaction in
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top, spacing: 16) {
                    Text(transaction.description)
                        .font(Font.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Spacer()
                    Text(transaction.amountDescription)
                        .currencyViewModifier(size: 22,
                                              classification: transaction.classification)
                }
                Text(transaction.relativeDateDescription)
                    .foregroundColor(.secondary)
            }
        }
    }
}


// MARK: - TransactionCell Previews
struct TransactionCell_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { colorScheme in
            TransactionCell(id: model.transactions[0].id)
                .background(Color("BackgroundColor"))
                .colorScheme(colorScheme)
        }.environmentObject(model)
            .previewLayout(.sizeThatFits)
    }
}
