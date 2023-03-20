//
//  LocationView.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import SwiftUI
import MapKit
import XpenseModel


// MARK: - LocationView
/// A view to showcase a location on a map
struct LocationView: View {
    /// The default values for the `LocationView` shared across the Xpense Application
    enum Defaults {
        /// The default span for the `LocationView`
        static let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
    
    
    /// The coordinate of the pin on the map
    var coordinate: CLLocationCoordinate2D
    /// The current coordinate region displayed by the map
    @State var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(),
                                                     span: Defaults.span)
    
    var body: some View {
        Map(coordinateRegion: $coordinateRegion,
            annotationItems: [IdentifiableCoordinate2DWrapper(coordinate: coordinate)]) { coordinateWrapper in
            MapMarker(coordinate: coordinateWrapper.coordinate)
        }.task {
            coordinateRegion.center = coordinate
        }
    }
}


// MARK: - LocationView Previews
struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView(coordinate: MockModel().transactions[0].location?.clCoordinate ?? CLLocationCoordinate2D())
    }
}
