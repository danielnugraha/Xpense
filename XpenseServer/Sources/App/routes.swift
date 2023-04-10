//
//  routes.swift
//  XpenseServer
//
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Fluent
import Vapor

func routes(_ app: Application) throws {
    let routes = app.grouped("v1")
    
    routes.get { _ async throws -> String in
        "Hello world"
    }
    
    try routes.register(collection: AccountController())
    try routes.register(collection: AuthenticationController())
    try routes.register(collection: TransactionController())
}
