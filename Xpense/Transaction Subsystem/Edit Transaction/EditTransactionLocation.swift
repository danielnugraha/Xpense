//
//  EditTransactionLocation.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/26/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


// MARK: - EditTransactionLocation
struct EditTransactionLocation: View {
    /// The `EditTransactionViewModel` that manages the content of the view
    @ObservedObject var viewModel: EditTransactionViewModel
    
    
    var body: some View {
        Section(header: Text("Location")) {
            HStack {
                if let location = viewModel.location {
                    LocationView(coordinate: location)
                        .aspectRatio(1, contentMode: .fit)
                        .cornerRadius(3.0)
                } else {
                    Text("Select a location ...")
                        .foregroundColor(Color("FormPlaceholder"))
                }
            }
                .onTapGesture {
                    viewModel.showLocationSelectionView = true
                }
                .sheet(isPresented: $viewModel.showLocationSelectionView) {
                    EditLocationView(coordinate: $viewModel.location)
                }
        }
    }
}


// MARK: - EditTransactionLocation Previews
struct EditTransactionLocation_Previews: PreviewProvider {
    private static let model: Model = MockModel()
    
    
    static var previews: some View {
        EditTransactionLocation(viewModel: EditTransactionViewModel(model, id: model.transactions[0].id))
            .environmentObject(model)
    }
}
