//
//  User.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 08.03.23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: User
/// Represents a User of the Xpense Application
public struct User {
    /// The name of the User of the Xpense Application
    public var name: String
    /// The token that is used to authenticate the `User` on the XpenseServer
    var token: String?
    
    
    /// The `token` of the `User` transformed into the bearer token format
    var bearerToken: String? {
        token.map { "Bearer \($0)" }
    }
    
    /// - Parameters:
    ///   - name: The name of the User of the Xpense Application
    ///   - token: The token that is used to authenticate the `User` on the XpenseServer
    init(name: String, token: String? = nil) {
        self.name = name
        self.token = token
    }
}


// MARK: User: Codable
extension User: Codable {}
