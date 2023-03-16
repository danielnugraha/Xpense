//
//  LocationDetailLink.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit
import XpenseModel


// MARK: - LocationDetailLink
/// A view to showcase a location on a map with the option to click on the map to interact with using a `NavigationLink`
struct LocationDetailLink: View {
    /// The coordinate that should be displayed
    var coordinate: CLLocationCoordinate2D
    /// The navigationbar title that should be displayed in the detail view
    var navigationTitle: String
    
    
    var body: some View {
        NavigationLink(destination: locationView) {
            LocationView(coordinate: coordinate)
                .disabled(true)
                .aspectRatio(1.0, contentMode: .fit)
                .cardViewModifier()
                .padding(16)
        }
    }
    
    /// The `LocationView` that should be displayed in the detail view
    private var locationView: some View {
        LocationView(coordinate: coordinate)
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle(navigationTitle)
    }
}


// MARK: - LocationDetailLink Previews
struct LocationDetailLink_Previews: PreviewProvider {
    private static var transaction = MockModel().transactions[0]
    
    
    static var previews: some View {
        NavigationStack {
            LocationDetailLink(coordinate: transaction.location?.clCoordinate ?? CLLocationCoordinate2D(),
                               navigationTitle: transaction.description)
        }
    }
}
