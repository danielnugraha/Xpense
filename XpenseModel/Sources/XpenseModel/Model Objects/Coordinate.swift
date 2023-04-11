//
//  Coordinate.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: Coordinate
/// Represents a single point on earth, specified by latitude and longitude.
public struct Coordinate {
    /// The latitude of the Coordinate
    var latitude: Double
    /// The longitude of the Coordinate
    var longitude: Double
    
    /// This `Transaction`'s location stored as a 2D Core Location Coordinate
    public var clCoordinate: CLLocationCoordinate2D? {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    /// - Parameters:
    ///   - latitude: The latitude of the Coordinate
    ///   - longitude: The longitude of the Coordinate
    public init(_ latitude: Double, _ longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// - Parameters:
    ///   - coordinate: The Core Location 2D coordindate that should be used to initialize the `Coordinate`
    public init(_ coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }
}

// MARK: Coordinate: Codable
extension Coordinate: Codable {}

// MARK: Coordinate: Hashable
extension Coordinate: Hashable {}
