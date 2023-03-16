//
//  EditAccountViewModel.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/26/20.
//  Rewritten by Daniel Nugraha on 09/03/23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import CoreLocation
import XpenseModel
import SwiftUI


// MARK: EditAccountViewModel
class EditAccountViewModel: ObservableObject {
    /// The `Account`'s name
    @Published var name: String = ""
    /// Indicates whether the deletion alert should be displayed
    @Published var showDeleteAlert = false
    /// Indicates whether the save button should show a Progress Indicator
    @Published var showSaveProgressView = false
    /// Indicates whether the delete button should show a Progress Indicator
    @Published var showDeleteProgressView = false
    
    /// The `Account`'s identifier that should be edited
    var id: XpenseModel.Account.ID
    /// The `Model` that is used to interact with the `Account`s of the Xpense application
    private weak var model: Model?
    
    
    /// The Accounts of the Xpense App loaded from the `Model`
    var accounts: [Account] {
        model?.accounts ?? []
    }
    /// Indicates if the save `Button` should be disabled
    var disableSaveButton: Bool {
        showSaveProgressView || showDeleteProgressView
    }
    
    
    /// - Parameter model: The `Model` that is used to interact with the `Account`s of the Xpense application
    /// - Parameter id: The `Account`'s identifier that should be edited
    init(_ model: Model, id: XpenseModel.Account.ID) {
        self.model = model
        self.id = id
    }
    
    
    /// Updates the `EditViews`'s state like the name based on the `id`
    func updateStates() {
        guard let account = model?.account(id) else {
            self.name = ""
            return
        }
        
        self.name = account.name
    }
    
    /// Saves the `Account` that is currently edited
    func save() async {
        guard let model = model else {
            return
        }
        
        let account = Account(id: self.id, name: self.name)
        
        DispatchQueue.main.async {
            self.showSaveProgressView = true
        }
    
        await model.save(account)
        
        DispatchQueue.main.async {
            self.updateStates()
            self.showSaveProgressView = false
        }
    }
    
    /// Deletes the `Account` that is currently edited
    func delete() async {
        guard let id = id, let model = model else {
            return
        }
        DispatchQueue.main.async {
            self.showDeleteProgressView = true
        }
        
        await model.delete(account: id)
        DispatchQueue.main.async {
            self.updateStates()
            self.showDeleteProgressView = false
        }
    }
}


// MARK: EditAccountViewModel + ErrorViewModel
extension EditAccountViewModel: ErrorViewModel {
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


// MARK: EditAccountViewModel + SaveButtonViewModel
extension EditAccountViewModel: SaveButtonViewModel {}
