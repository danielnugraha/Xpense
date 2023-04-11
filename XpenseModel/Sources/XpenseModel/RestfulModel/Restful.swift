//
//  Restful.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Rewritten by Daniel Nugraha on 08.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation

// MARK: Restful
/// A Restful Element that can be created, read, updated, and deleted from a Restful Server
protocol Restful: Codable & Identifiable & Comparable {
    /// The route that should be used to retrieve and store the RESTful Element from the Server
    static var route: URL { get }
    
    /// Gets the elements from the RESTful Server
    static func get() async throws -> [Self]
    
    /// Deletes the element from the Restful Server
    static func delete(id: Self.ID) async throws
    
    /// Posts the element to the Restful Server
    func post() async throws -> Self
    
    /// Puts the element to the Restful Server
    func put() async throws -> Self
}

// MARK: Restful
extension Restful where Self.ID == UUID? {
    static func get() async throws -> [Self] {
        do {
            return try await NetworkManager.getElements(on: Self.route)
        } catch {
            throw XpenseServiceError.loadingFailed(Self.self)
        }
    }
    
    func post() async throws -> Self {
        try await NetworkManager.postElement(self, on: Self.route)
    }
}

// MARK: Restful + Identifiable UUID
extension Restful where Self.ID == UUID? {
    static func delete(id: Self.ID) async throws {
        try await NetworkManager.delete(at: Self.route.appendingPathComponent(id?.uuidString ?? ""))
    }
    
    func put() async throws -> Self {
        try await NetworkManager.putElement(self, on: Self.route.appendingPathComponent(self.id?.uuidString ?? ""))
    }
}
