//
//  Account.swift
//  XpenseServer
//  
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Vapor
import Fluent

final class Account: Model, Content {
    static let schema = "accounts"

    /// The stable identity of the `Account`
    @ID(key: .id)
    var id: UUID?
    
    /// The name of the `Account`
    @Field(key: "name")
    var name: String
    
    @Parent(key: "user_id")
    var user: User
    
    /// The `Transaction`s that are associated with the `Account`
    @Children(for: \.$account)
    var transactions: [Transaction]
    
    init() { }
    
    init(id: UUID? = UUID(), name: String, userId: User.IDValue) {
        self.id = id
        self.name = name
        self.$user.id = userId
    }
}

extension Account {
    struct Migration: AsyncMigration {
        func prepare(on database: FluentKit.Database) async throws {
            try await database.schema("accounts")
                .id()
                .field("name", .string, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .create()
        }
        
        func revert(on database: FluentKit.Database) async throws {
            try await database.schema("accounts").delete()
        }
    }
}

extension Account {
    struct InputOutput: Content {
        /// The stable identity of the entity associated with self
        public var id: UUID?
        /// The name of the `Account`
        public var name: String
    }
    
    func toInputOutput() -> Account.InputOutput {
        InputOutput(id: id, name: name)
    }
}
