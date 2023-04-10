//
//  TransactionController.swift
//  XpenseServer
//  
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Vapor
import Fluent


struct TransactionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.grouped(UserToken.authenticator())
        let transactions = tokenProtected.grouped("transactions")
        transactions.get(use: index)
        transactions.post(use: create)
        transactions.group(":transactionID") { transaction in
            transaction.put(use: update)
            transaction.get(use: read)
            transaction.delete(use: delete)
        }
    }
    
    func index(req: Request) async throws -> [Transaction.InputOutput] {
        let user = try req.auth.require(User.self)
        return try await Transaction
            .query(on: req.db)
            .with(\.$account)
            .join(parent: \.$account)
            .filter(Account.self, \Account.$user.$id == user.id)
            .all()
            .map { $0.toInputOutput() }
    }
    
    func create(req: Request) async throws -> Transaction.InputOutput {
        let user = try req.auth.require(User.self)
        let newTransaction = try req.content.decode(Transaction.InputOutput.self)
        
        let transaction = newTransaction.toTransaction()
        
        let transAccount = try await transaction.$account.get(on: req.db)
        guard transAccount.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        try await transaction.create(on: req.db)
        return transaction.toInputOutput()
    }
    
    func update(req: Request) async throws -> Transaction.InputOutput {
        let user = try req.auth.require(User.self)
        let newTransaction = try req.content.decode(Transaction.InputOutput.self)
        
        guard let transaction = try await Transaction.find(
            newTransaction.id,
            on: req.db
        ) else {
            throw Abort(.notFound)
        }
        
        let transAccount = try await transaction.$account.get(on: req.db)
        guard transAccount.$user.id == user.id && transaction.id == newTransaction.id else {
            throw Abort(.forbidden)
        }
        
        transaction.update(with: newTransaction)
        
        try await transaction.save(on: req.db)
        return transaction.toInputOutput()
    }
    
    func read(req: Request) async throws -> Transaction.InputOutput {
        let user = try req.auth.require(User.self)
        
        guard let transaction = try await Transaction.find(
            req.parameters.get("transactionID"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }
        
        let transAccount = try await transaction.$account.get(on: req.db)
        guard transAccount.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        return transaction.toInputOutput()
    }
    
    func delete(req: Request) async throws -> Transaction.InputOutput {
        let user = try req.auth.require(User.self)
        
        guard let transaction = try await Transaction.find(
            req.parameters.get("transactionID"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }
        
        let transAccount = try await transaction.$account.get(on: req.db)
        guard transAccount.$user.id == user.id else {
            throw Abort(.forbidden)
        }
        
        try await transaction.delete(on: req.db)
        return transaction.toInputOutput()
    }
}
