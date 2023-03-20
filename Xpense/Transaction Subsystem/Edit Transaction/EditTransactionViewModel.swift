//
//  EditTransactionViewModel.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/25/20.
//  Rewritten by Daniel Nugraha on 9/3/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation
import CoreLocation
import XpenseModel
import SwiftUI


// MARK: EditTransactionViewModel
class EditTransactionViewModel: ObservableObject {
    /// The `Transaction`'s amount, the default amount is 0
    @Published var amount: Double?
    /// The `Transaction`'s classification
    @Published var classification: XpenseModel.Transaction.Classification = .income
    /// The `Transaction`'s description
    @Published var description: String = ""
    /// The `Transaction`'s date and time, the default value is the current date and time
    @Published var date = Date()
    /// The `Transaction`'s location
    @Published var location: CLLocationCoordinate2D?
    /// The `Transaction`'s `Account`
    @Published var selectedAccount: XpenseModel.Account.ID = nil
    /// Indicates whether the transaction was already loaded based on the injected `model` property
    @Published var loaded = false
    /// Indicates whether the save button should show a Progress Indicator
    @Published var showLocationSelectionView = false
    /// Indicates whether the save button should show a Progress Indicator
    @Published var showSaveProgressView = false
    
    /// The `Transaction`'s identifier that should be edited
    var id: XpenseModel.Transaction.ID
    /// The `Model` that is used to interact with the `Transaction`s of the Xpense application
    private weak var model: Model?
    
    
    /// The Accounts of the Xpense App loaded from the `Model`
    var accounts: [Account] {
        model?.accounts ?? []
    }
    /// Indicates if the save `Button` should be disabled
    var disableSaveButton: Bool {
        selectedAccount == nil || description.isEmpty || amount == nil || location == nil
    }
    
    
    /// - Parameter model: The `Model` that is used to interact with the `Transaction`s of the Xpense application
    /// - Parameter id: The `Transaction`'s identifier that should be edited
    init(_ model: Model, id: XpenseModel.Transaction.ID) {
        self.model = model
        self.id = id
    }
    
    
    /// Updates the `EditTransaction`'s state like the name based on the `id`
    func updateStates() {
        guard let transaction = model?.transaction(id), !loaded else {
            return
        }
        
        // Fill attributes from existing transaction
        self.amount = centToDouble(cent: abs(transaction.amount))
        self.classification = transaction.classification
        self.description = transaction.description
        self.date = transaction.date
        self.location = transaction.location?.clCoordinate
        self.selectedAccount = transaction.account
        
        // Indicate that the content has been loaded to we don't reset properties if
        // we e.g. navigate into a child view using `NavigationLink`s
        self.loaded = true
    }
    
    /// Saves the `Transaction` that is currently edited
    func save() async {
        guard let amount = amount,
              let selectedAccount = selectedAccount,
              let location = location,
              let model = model else {
            return
        }
    
        let transaction = Transaction(id: self.id,
                                      amount: doubleToCent(double: amount) * classification.factor,
                                      description: self.description,
                                      date: self.date,
                                      location: Coordinate(location),
                                      account: selectedAccount)
        
        DispatchQueue.main.async {
            self.showSaveProgressView = true
        }
        await model.save(transaction)
        
        DispatchQueue.main.async {
            self.updateStates()
            self.showSaveProgressView = false
        }
    }
    
    private func centToDouble(cent: Int) -> Double {
        Double(cent) / 100
    }
    
    private func doubleToCent(double: Double) -> Int {
        Int(double * 100)
    }
}


// MARK: EditTransactionViewModel + ErrorViewModel
extension EditTransactionViewModel: ErrorViewModel {
    var errorMessage: String? {
        self.model?.errorMessage
    }
    
    var presentingErrorMessage: Binding<Bool> {
        Binding(get: {
            self.model?.presentingErrorMessage.wrappedValue ?? false
        }, set: { newValue in
            self.model?.presentingErrorMessage.wrappedValue = newValue
        })
    }
}


// MARK: EditTransactionViewModel + SaveButtonViewModel
extension EditTransactionViewModel: SaveButtonViewModel {}
