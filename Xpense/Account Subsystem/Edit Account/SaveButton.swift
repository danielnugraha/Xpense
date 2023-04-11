//
//  EditAccountSaveButton.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/26/20.
//  Rewritten by Daniel Nugraha on 9/3/23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel

/// The view model used for the `SaveButton`
protocol SaveButtonViewModel: ObservableObject {
    /// Indicates if the save button should be disabled
    var disableSaveButton: Bool { get }
    /// Indicates if the save button progress indicator should be shown
    var showSaveProgressView: Bool { get set }
    
    /// The action that should be performed by the save button
    func save() async
}

// MARK: - SaveButton
/// Button that is used to save the edits made to a model conforming to `SaveButtonViewModel`
struct SaveButton<M: SaveButtonViewModel>: View {
    /// Indicates whether this `EditAccount` view is currently presented
    @Environment(\.dismiss) private var dismiss
    
    /// The `SaveButtonViewModel` that manages the content of the view
    @ObservedObject var viewModel: M
    var additionalAction: (() -> Void)?

    var body: some View {
        Button(action: save) {
            Text("Save")
                .bold()
        }.disabled(viewModel.disableSaveButton)
            .buttonStyle(ProgressViewButtonStyle(animating: $viewModel.showSaveProgressView))
    }

    /// Saves the element using the view model
    private func save() {
        additionalAction?()
        Task {
            await viewModel.save()
            dismiss()
        }
    }
}
