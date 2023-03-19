//
//  User.swift
//  XpenseServer
//  
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Vapor
import Fluent

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var name: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    @Children(for: \.$user)
    var accounts: [Account]
    
    init() { }
           
    init(id: UUID? = nil, name: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.passwordHash = passwordHash
    }
    

}

extension User {
    func generateToken() throws -> UserToken {
        try .init(
            value: [UInt8].random(count: 16).base64,
            userId: self.requireID()
        )
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$name
    static let passwordHashKey = \User.$passwordHash
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User {
    struct Migration: AsyncMigration {
        func prepare(on database: FluentKit.Database) async throws {
            try await database.schema("users")
                .id()
                .field("username", .string, .required)
                .field("password_hash", .string, .required)
                .field("accounts", .array(of: .uuid), .references("accounts", "id"))
                .create()
        }
        
        func revert(on database: FluentKit.Database) async throws {
            try await database.schema("users").delete()
        }
    }
}

extension User {
    struct InputOutput: Content {
        var name: String
        var password: String
    }
}
