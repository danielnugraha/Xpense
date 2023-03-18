//
//  EditTransaction.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 11/03/23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel
import CoreLocation


// MARK: - EditTransaction
/// A view that enables the user to edit a `Transaction`
struct EditTransaction: View {
    /// Indicates whether this `EditAccount` view is currently presented
    @Environment(\.presentationMode) private var presentationMode
    /// The `EditTransactionViewModel` that manages the content of the view
    @ObservedObject private var viewModel: EditTransactionViewModel
    
    
    /// The title in the navigation bar for this view
    var navigationTitle: String {
        viewModel.id == nil ? "Create Transaction" : "Edit Transaction"
    }
    
    
    /// - Parameter model: The `Model` that is used to manage the `Transaction`s of the Xpense Application
    /// - Parameter id: The `Transaction`'s identifier that should be edited
    init(_ model: Model, id: XpenseModel.Transaction.ID) {
        viewModel = EditTransactionViewModel(model, id: id)
    }
    
    
    var body: some View {
        NavigationStack {
            self.form
                .onAppear(perform: viewModel.updateStates)
                .navigationBarTitle(navigationTitle, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        SaveButton(viewModel: viewModel)
                    }
                }
                .alert(isPresented: viewModel.presentingErrorMessage) {
                    Alert(title: Text("Error"),
                          message: Text(viewModel.errorMessage ?? ""))
                }
        }.disabled(viewModel.showSaveProgressView)
    }
    
    /// The `From` component of the `EditTransaction` view
    private var form: some View {
        Form {
            EditTansactionAmountView(viewModel: viewModel)
            
            Section(header: Text("Description")) {
                TextField("Description", text: $viewModel.description)
            }
            
            Section(header: Text("Account")) {
                Picker("Account", selection: $viewModel.selectedAccount) {
                    Text("None selected").tag(nil as UUID?)
                    ForEach(viewModel.accounts) { account in
                        Text(account.name).tag(account.id)
                    }
                }
            }
            
            Section(header: Text("Date")) {
                DatePicker(selection: $viewModel.date,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute]) {
                    Text("Date")
                }
            }
            
            EditTransactionLocation(viewModel: viewModel)
        }
    }
}


// MARK: - EditTransaction Previews
struct EditTransaction_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    
    static var previews: some View {
        EditTransaction(model, id: model.transactions[0].id)
            .environmentObject(model)
    }
}
