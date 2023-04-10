//
//  AccountController.swift
//  XpenseServer
//  
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Vapor
import Fluent

struct AccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(UserToken.authenticator())
        
        let accounts = tokenProtected.grouped("accounts")
        accounts.get(use: index)
        accounts.post(use: create)
        accounts.group(":accountID") { account in
            account.put(use: update)
            account.get(use: read)
            account.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [Account.InputOutput] {
        try await req.auth.require(User.self)
            .$accounts
            .query(on: req.db)
            .all()
            .map { $0.toInputOutput() }
    }
    
    func create(req: Request) async throws -> Account.InputOutput {
        let user = try req.auth.require(User.self)
        let newAccount = try req.content.decode(Account.InputOutput.self)
        
        guard let userId = user.id else {
            throw Abort(.notFound)
        }
        
        let account = Account(id: newAccount.id, name: newAccount.name, userId: userId)
        
        try await account.create(on: req.db)
        return Account.InputOutput(id: account.id, name: account.name)
    }
    
    func update(req: Request) async throws -> Account.InputOutput {
        let user = try req.auth.require(User.self)
        let newAccount = try req.content.decode(Account.InputOutput.self)
        
        guard let account = try await Account.find(
            newAccount.id,
            on: req.db
        ) else {
            throw Abort(.notFound)
        }
        
        guard account.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        account.name = newAccount.name
        
        try await account.save(on: req.db)
        return account.toInputOutput()
    }
    
    func read(req: Request) async throws -> Account.InputOutput {
        let user = try req.auth.require(User.self)
        
        guard let account = try await Account.find(
            req.parameters.get("accountID"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }
        
        guard account.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        return account.toInputOutput()
    }
    
    func delete(req: Request) async throws -> Account.InputOutput {
        let user = try req.auth.require(User.self)
        
        guard let account = try await Account.find(
            req.parameters.get("accountID"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }
        
        guard account.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        try await account.delete(on: req.db)
        return account.toInputOutput()
    }
}
