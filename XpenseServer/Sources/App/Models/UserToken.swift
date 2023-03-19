//
//  UserToken.swift
//  XpenseServer
//  
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Vapor
import Fluent

final class UserToken: Model, Content {
    static let schema = "user_tokens"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "value")
    var value: String
    
    @Parent(key: "user_id")
    var user: User
    
    init() { }
    
    init(id: UUID? = UUID(), value: String, userId: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userId
    }
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user
    
    var isValid: Bool {
        true
    }
}

extension UserToken {
    struct Migration: AsyncMigration {
        func prepare(on database: FluentKit.Database) async throws {
            try await database.schema("user_tokens")
                .id()
                .field("value", .string, .required)
                .field("user_id", .uuid, .required, .references("users", "id"))
                .create()
        }
        
        func revert(on database: FluentKit.Database) async throws {
            try await database.schema("user_tokens").delete()
        }
    }
}

extension UserToken {
    struct Output: Content {
        var name: String
        var token: String
    }
}
