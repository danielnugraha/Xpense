//
//  WelcomeToXpenseView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/8/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI


// MARK: - WelcomeToXpenseView
/// The view that displays the Xpense logo as well as a logo text
struct WelcomeToXpenseView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image("Xpense")
                .resizable()
                .scaledToFit()
                .mask(RoundedRectangle(cornerRadius: 50))
                .frame(width: 200)
                .shadow(radius: 10)
            Spacer()
                .frame(minHeight: 0, idealHeight: 32, maxHeight: 32)
            Text("Welcome to")
                .font(.system(size: 20))
            Text("Xpense")
                .font(.system(size: 55)).bold()
            Spacer()
                .frame(minHeight: 8, idealHeight: 48, maxHeight: 48)
        }
    }
}


// MARK: - WelcomeToXpenseView Previews
struct WelcomeToXpenseView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeToXpenseView()
    }
}
