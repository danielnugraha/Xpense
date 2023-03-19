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
    enum Field {
        case amount
        case description
    }
    /// Indicates whether this `EditAccount` view is currently presented
    @Environment(\.presentationMode) private var presentationMode
    /// The `EditTransactionViewModel` that manages the content of the view
    @ObservedObject private var viewModel: EditTransactionViewModel
    @FocusState private var focusedField: Field?
    
    /// A `Binding` that is used to translate the output of a `TextField` to a double value according to the `NumberFormatter.decimalAmount` defined
    /// in the XpenseModel Swift Package.
    ///
    /// This is a workaround as using a `NumberFormatter` in the `TextField` does currently not work in our use case.
    var amountString: Binding<String> {
        Binding(get: {
            guard let amount = viewModel.amount else {
                return ""
            }
            return NumberFormatter.decimalAmount.string(from: NSNumber(value: amount)) ?? ""
        }, set: {
            print($0)
            viewModel.amount = NumberFormatter.decimalAmount.number(from: $0)?.doubleValue
        })
    }
    
    
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
                .task {
                    viewModel.updateStates()
                }
                .navigationBarTitle(navigationTitle, displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        SaveButton(viewModel: viewModel)
                            .onTapGesture {
                                focusedField = nil
                            }
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
            Section(header: Text("Amount")) {
                HStack {
                    HStack(alignment: .center, spacing: 2) {
                        Text("\(viewModel.classification.sign)")
                        TextField("Amount", value: $viewModel.amount, format: .currency(code: "EUR"))
                            .keyboardType(.decimalPad) // Show only numbers and a dot
                            .focused($focusedField, equals: .amount)
                    }
                    
                    Picker("Transaction Type", selection: $viewModel.classification) {
                        ForEach(XpenseModel.Transaction.Classification.allCases) { transactionType in
                            Text(transactionType.rawValue).tag(transactionType)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
            }
            
            Section(header: Text("Description")) {
                TextField("Description", text: $viewModel.description)
                    .focused($focusedField, equals: .description)
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
                Button(action: {focusedField = nil}) {
                    Text("Unfocus")
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
