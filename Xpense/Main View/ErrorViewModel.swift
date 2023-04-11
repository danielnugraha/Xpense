//
//  ErrorViewModel.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel

// MARK: ErrorViewModel
/// The `ErrorViewModel` that is responsible for showing errors originating from the `Model`
protocol ErrorViewModel: ObservableObject {
    /// The human readable error message that should be displayed to the user
    var errorMessage: String? { get }
    /// A `Bool` `Binding` that indicates whether there is a error message that should be displayed
    var presentingErrorMessage: Binding<Bool> { get }
}

// MARK: Model + ErrorViewModel
extension Model: ErrorViewModel {
    var errorMessage: String? {
        self.serverError?.localizedDescription
    }
    
    var presentingErrorMessage: Binding<Bool> {
        Binding(get: {
            self.serverError != nil
        }, set: { newValue in
            guard !newValue else {
                return
            }
            self.resolveServerError()
        })
    }
}
