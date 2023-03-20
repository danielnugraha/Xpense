//
//  IdentifiableCoordinate2DWrapper.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 9/18/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import MapKit


/// Used to have identifiable annotation items for a SwiftUI Map View
struct IdentifiableCoordinate2DWrapper: Identifiable {
    /// Uniquly identifies a `IdentifiableCoordinate2DWrapper`
    var id = UUID()
    /// The coordinate that should be displayed on the map
    var coordinate: CLLocationCoordinate2D
}
