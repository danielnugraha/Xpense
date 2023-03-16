//
//  AccountDetailLink.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 11/03/23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - AccountDetailLink
/// A label with a card background showing the name of an `Account` and the option to navigate to that `Account`
struct AccountDetailLink: View {
    /// The `Model` the   `Account` shall be read from
    @EnvironmentObject private var model: Model
    /// Indicate whether to disable the navigation link
    var disableLink: Bool
    
    /// The `Account`'s identifier that should be used to display the corresponding `Account`
    ///
    /// We do explicitly **not** wrap this property with an `@State` property wrapper as this would not update the `AccountDetailLink` if the
    /// parent view's properties marked with `@State` are changed, and the view should be redrawn.
    ///
    /// Wrapping the property with `@State` would move the storage of the property out if the `AccountDetailLink` struct. This would result in
    /// SwiftUI injecting the value every time the view is evaluated, resulting in an outdated view representation.
    var id: Account.ID
    
    
    var body: some View {
        model.account(id).map { account in
            HStack {
                Text(account.name)
                Spacer()
                if disableLink {
                    Image(systemName: "chevron.right")
                }
            }
            .onTapGesture {
                model.path.append(account)
            }
            .padding(16)
                .cardViewModifier()
                .foregroundColor(.primary)
                .padding(16)
                    .disabled(disableLink)
        }
    }
}


// MARK: - AccountDetailLink Previews
struct AccountDetailLink_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    private static var accountId = model.accounts[0].id
    
    
    static var previews: some View {
        ForEach(ContentSizeCategory.allCases, id: \.hashValue) { contentSizeCategory in
            AccountDetailLink(disableLink: false, id: accountId)
                .environment(\.sizeCategory, contentSizeCategory)
        }.environmentObject(model)
            .background(Color("BackgroundColor"))
            .previewLayout(.sizeThatFits)
    }
}
