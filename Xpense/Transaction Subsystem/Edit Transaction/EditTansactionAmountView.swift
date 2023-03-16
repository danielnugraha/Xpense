//
//  EditTansactionAmountView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - EditTansactionAmountView
/// A view to edit a `Transaction`'s amount and classification
struct EditTansactionAmountView: View {
    /// The `EditTransactionViewModel` that manages the content of the view
    @ObservedObject var viewModel: EditTransactionViewModel
    
    
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
            viewModel.amount = NumberFormatter.decimalAmount.number(from: $0)?.doubleValue
        })
    }
    
    var body: some View {
        Section(header: Text("Amount")) {
            HStack {
                HStack(alignment: .center, spacing: 2) {
                    Text("\(viewModel.classification.sign)")
                    // Unfortunately `TextField("Amount", value: $amount, formatter: NumberFormatter.decimalAmount)` does not work at the moment.
                    // While the `TextField` does show the correct value the binding is only updated when the user presses the return key on the
                    // software or hardware keyboard at the moment. As we use the `.decimalPad` keyboard type we can not use this at the moment.
                    TextField("Amount", text: amountString)
                        .keyboardType(.decimalPad) // Show only numbers and a dot
                }
                
                Picker("Transaction Type", selection: $viewModel.classification) {
                    ForEach(XpenseModel.Transaction.Classification.allCases) { transactionType in
                        Text(transactionType.rawValue).tag(transactionType)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
        }
    }
}


// MARK: - EditAmount Previews
struct EditAmount_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    
    static var previews: some View {
        Form {
            EditTansactionAmountView(viewModel: EditTransactionViewModel(model, id: model.transactions[0].id))
        }
    }
}
