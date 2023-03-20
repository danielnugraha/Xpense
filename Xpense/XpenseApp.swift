//
//  XpenseApp.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/8/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import XpenseModel


@main
struct XpenseApp: App {
    @StateObject var model: Model = RestfulModel()
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .alert(isPresented: model.presentingErrorMessage) {
                    Alert(title: Text("Error"),
                          message: Text(model.errorMessage ?? ""))
                }
                .environmentObject(model)
        }
    }
}
