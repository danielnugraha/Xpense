//
//  TabContentCoordinator.swift
//  Xpense
//
//  Created by Daniel Nugraha on 20.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation
import SwiftUI
import XpenseModel

open class ContentState: ObservableObject {
    @Published var path: [ContentLink] = []
    @Published var presentedItem: ContentLink?
}

struct ContentCoordinator<Content: View>: View {
    /// The `Model` the   `Transaction`s shall be read from
    @EnvironmentObject private var model: Model
    
    let content: (Binding<[ContentLink]>) -> Content
    let contentType: ContentLink
    
    var navigationTitle: String {
        switch contentType {
        case .accountLink:
            return "Accounts"
        case .transactionLink:
            return "Transactions"
        }
    }
    
    @ObservedObject var contentState = ContentState()
    /// Indicates whether the alert asking to confirm the logout process should be displayed
    @State private var presentUserAlert = false
    
    init(content: @escaping (Binding<[ContentLink]>) -> Content, contentType: ContentLink) {
        self.content = content
        self.contentType = contentType
    }
    
    var body: some View {
        NavigationStack(path: $contentState.path) {
            content($contentState.path)
                .navigationTitle(navigationTitle)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        UserButton(presentUserAlert: $presentUserAlert)
                    }
                    ToolbarItem(placement: .primaryAction) {
                        addButton
                    }
                }
                .alert(isPresented: $presentUserAlert) {
                    UserButton.createLogoutAlert(model)
                }
                .sheet(item: $contentState.presentedItem, content: sheetContent)
                .navigationDestination(for: ContentLink.self) { contentLink in
                    switch contentLink {
                    case .transactionLink(let id):
                        TransactionView(contentState: contentState, id: id)
                    case .accountLink(let id):
                        AccountView(contentState: contentState, id: id)
                    }
                }
        }
    }
    
    /// Button that is used to add a new `Transaction`
    private var addButton: some View {
        Button(action: { self.contentState.presentedItem = contentType }) {
            Image(systemName: "plus")
        }
    }
    
    @ViewBuilder private func sheetContent(item: ContentLink) -> some View {
        switch item {
        case let .transactionLink(id):
            EditTransaction(self.model, id: id)
        case let .accountLink(id):
            EditAccount(self.model, path: $contentState.path, id: id)
        }
    }
    
}

enum ContentLink: Hashable, Identifiable {
    case transactionLink(id: XpenseModel.Transaction.ID = nil)
    case accountLink(id: XpenseModel.Account.ID = nil)

    var id: String {
        String(describing: self)
    }
}
