//
//  EditAccount.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha 9/3/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel

// MARK: - EditAccount
/// A view that enables the user to edit an `Account`
struct EditAccount: View {
    /// The `EditAccountViewModel` that manages the content of the view
    @StateObject private var viewModel: EditAccountViewModel
    @Binding private var path: [ContentLink]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Account Name", text: $viewModel.name)
                }
                if viewModel.id != nil {
                    DeleteButton(viewModel: viewModel) {
                        let deletedInPath = self.path.contains { contentLink in
                            switch contentLink {
                            case .accountLink(let id):
                                return id == viewModel.id
                            default:
                                return false
                            }
                        }
                        if deletedInPath {
                            self.path = []
                        }
                    }
                }
            }
            .task {
                viewModel.updateStates()
            }
            .navigationBarTitle(viewModel.id == nil ? "Add Account" : "Edit Account", displayMode: .inline)
            .toolbar {
                SaveButton(viewModel: viewModel)
                    .alert(isPresented: viewModel.presentingErrorMessage) {
                        Alert(title: Text("Error"),
                              message: Text(viewModel.errorMessage ?? ""))
                    }
            }
        }
    }
    
    /// - Parameter model: The `Model` that is used to manage the `Account`s of the Xpense Application
    /// - Parameter id: The `Account`'s identifier that should be edited
    init(_ model: Model, path: Binding<[ContentLink]>, id: XpenseModel.Account.ID) {
        self._viewModel = StateObject(wrappedValue: EditAccountViewModel(model, id: id))
        self._path = path
    }
}

// MARK: - DeleteButton
/// A button that deletes an `Account` used in the `EditAccount` view
private struct DeleteButton: View {
    /// Indicates whether this `EditAccount` view is currently presented
    @Environment(\.dismiss) private var dismiss
    
    /// The `EditAccountViewModel` that manages the content of the view
    @ObservedObject var viewModel: EditAccountViewModel
    
    var additionalAction: (() -> Void)?
    
    var body: some View {
        Button(action: { viewModel.showDeleteAlert = true }) {
            HStack {
                Spacer()
                Text("Delete")
                Spacer()
            }
        }.buttonStyle(ProgressViewButtonStyle(animating: $viewModel.showDeleteProgressView,
                                              progressViewColor: .gray,
                                              foregroundColor: .red))
            .alert(isPresented: $viewModel.showDeleteAlert) {
                deleteAlert
            }
    }
    
    /// Alter that is used to verify that the user really wants to delete the `Account`
    private var deleteAlert: Alert {
        Alert(title: Text("Delete Account"),
              message: Text(
                "If you delete the Account you will also delete all Transactions associated with the Account"
              ),
              primaryButton: .destructive(Text("Delete"), action: delete),
              secondaryButton: .cancel())
    }
    
    /// Uses the `EditAccountViewModel` to delete the account
    private func delete() {
        Task {
            await viewModel.delete()
            additionalAction?()
            dismiss()
        }
    }
}

// MARK: - EditAccount Previews
struct EditAccount_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    @State private static var path: [ContentLink] = []
    
    static var previews: some View {
        EditAccount(model, path: $path, id: model.accounts[0].id)
            .environmentObject(model)
    }
}
