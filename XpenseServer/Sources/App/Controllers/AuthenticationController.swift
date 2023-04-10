//
//  AuthenticationController.swift
//  XpenseServer
//  
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Vapor
import Fluent

struct AuthenticationController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.post("users", use: createUser)
        
        let passwordProtected = routes.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
    }
    
    func createUser(req: Request) async throws -> User.InputOutput {
        var newUser = try req.content.decode(User.InputOutput.self)
        let passwordHash = try Bcrypt.hash(newUser.password)
        let user = User(id: UUID(), name: newUser.name, passwordHash: passwordHash)
        try await user.create(on: req.db)
        
        newUser.password = passwordHash
        return newUser
    }
    
    func login(req: Request) async throws -> UserToken.Output {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await token.save(on: req.db)
        return UserToken.Output(name: user.name, token: token.value)
    }
}
