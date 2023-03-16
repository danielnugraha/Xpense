//
//  configure.swift
//  XpenseServer
//
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Fluent
import FluentPostgresDriver
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .secondsSince1970
    ContentConfiguration.global.use(decoder: decoder, for: .json)
    ContentConfiguration.global.use(encoder: encoder, for: .json)
    
    switch app.environment {
    case .production:
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
        ), as: .psql)
    default:
        app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    }
    
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(Account.Migration())
    app.migrations.add(Transaction.Migration())

    // register routes
    try routes(app)
}
