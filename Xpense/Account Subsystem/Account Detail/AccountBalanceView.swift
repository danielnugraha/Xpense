//
//  AccountBalanceView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - AccountBalanceView
/// A rounded label displaying an `Account`'s balance
struct AccountBalanceView: View {
    /// The `Model` the   `Account` shall be read from
    @EnvironmentObject private var model: Model
    
    /// The `Account`'s identifier
    var id: Account.ID
    
    
    var body: some View {
        Group {
            model.account(id)?.balanceRepresentation(model).map { balance in
                Text(balance)
                    .foregroundColor(.primary)
                    .currencyViewModifier(size: 30, weight: .medium)
                    .padding(12)
                    .colorInvert()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 20))
            }
        }.padding(.horizontal, 16).padding(.vertical, 8)
    }
}


// MARK: - AccountBalanceView Previews
struct AccountBalanceView_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    @State private static var accountId = model.accounts[0].id
    
    
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { colorScheme in
            AccountBalanceView(id: accountId)
                .background(Color.black)
                .colorScheme(colorScheme)
        }.environmentObject(model)
            .previewLayout(.sizeThatFits)
    }
}
