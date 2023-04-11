//
//  AccountsGrid.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/25/20.
//  Rewritten by Daniel Nugraha on 20/03/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel

// MARK: - AccountsGrid
struct AccountsGrid: View {
    /// The `Model` the   `Account`s shall be read from
    @EnvironmentObject private var model: Model
    @Binding var path: [ContentLink]
    
    /// The columns of the `LazyVGrid` that enable a dynamic layout for differet device sizes
    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(model.accounts) { account in
                ZStack {
                    AccountBackground()
                        .frame(height: 140)
                    Button(action: { path.append(.accountLink(id: account.id)) }) {
                        VStack(spacing: 4) {
                            Text(account.name)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.primary)
                            Text(NumberFormatter.currencyRepresentation(from: account.balance(model)) ?? "")
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(.secondary)
                        }.padding()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - AccountsGrid Previews
struct AccountsGrid_Previews: PreviewProvider {
    @State static var path: [ContentLink] = []
    static var previews: some View {
        Group {
            NavigationStack {
                AccountsGrid(path: $path)
                    .navigationTitle("Accounts")
            }
            NavigationStack {
                AccountsGrid(path: $path)
                    .navigationTitle("Accounts")
                    .preferredColorScheme(.dark)
            }
        }.environmentObject(MockModel() as Model)
    }
}
