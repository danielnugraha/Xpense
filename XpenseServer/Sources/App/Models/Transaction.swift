//
//  Transaction.swift
//  XpenseServer
//  
//
//  Created by Daniel Nugraha on 13.03.23.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Vapor
import Fluent

final class Transaction: Model, Content {
    static let schema = "transactions"
    
    /// The stable identity of the `Transaction`
    @ID(key: .id)
    var id: UUID?
    
    /// The amount of money this transaction is worth in `Cent`s
    @Field(key: "amount")
    var amount: Int
    
    /// A textual description of the `Transaction`
    @Field(key: "description")
    var description: String
    
    /// The date this `Transaction` was executed
    @Field(key: "date")
    var date: Date
    
    /// The latitude of the Coordinate
    @Field(key: "latitude")
    var latitude: Double?
    
    /// The longitude of the Coordinate
    @Field(key: "longitude")
    var longitude: Double?
    
    /// The `Account` this `Transaction` is linked to
    @Parent(key: "account_id")
    var account: Account
    
    init() { }
    
    init(id: UUID? = UUID(),
         amount: Int,
         description: String,
         date: Date,
         latitude: Double?,
         longitude: Double?,
         accountId: Account.IDValue) {
        self.id = id
        self.amount = amount
        self.description = description
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.$account.id = accountId
    }
}

extension Transaction {
    struct Migration: AsyncMigration {
        func prepare(on database: FluentKit.Database) async throws {
            try await database.schema("transactions")
                .id()
                .field("amount", .int, .required)
                .field("description", .string, .required)
                .field("date", .date, .required)
                .field("latitude", .double)
                .field("longitude", .double)
                .field("account_id", .uuid, .required, .references("accounts", "id"))
                .create()
        }
        
        func revert(on database: FluentKit.Database) async throws {
            try await database.schema("transactions").delete()
        }
    }
}

extension Transaction {
    public struct InputOutput: Content {
        /// The stable identity of the entity associated with self
        public var id: UUID?
        /// The amount of money this transaction is worth in `Cent`s
        public var amount: Int
        /// A textual description of the `Transaction`
        public var description: String
        /// The date this `Transaction` was executed
        public var date: Date
        /// The location of the `Transaction` as a `Coordinate`
        public var location: Coordinate?
        /// The `Account` this `Transaction` is linked to
        public var account: UUID
        
        func toTransaction() -> Transaction {
            Transaction(
                id: id,
                amount: amount,
                description: description,
                date: date,
                latitude: location?.latitude,
                longitude: location?.longitude,
                accountId: account
            )
        }
    }
    
    struct Coordinate: Codable {
        /// The latitude of the Coordinate
        var latitude: Double
        /// The longitude of the Coordinate
        var longitude: Double
    }
    
    func toInputOutput() -> InputOutput {
        // swiftlint:disable:next force_unwrapping
        let id = account.id!
        var location: Coordinate?
        if let latitude = latitude, let longitude = longitude {
            location = Coordinate(latitude: latitude, longitude: longitude)
        }
        
        return InputOutput(
            id: id,
            amount: amount,
            description: description,
            date: date,
            location: location,
            account: id
        )
    }
    
    func update(with newTransaction: InputOutput) {
        self.amount = newTransaction.amount
        self.description = newTransaction.description
        self.date = newTransaction.date
        
        if let location = newTransaction.location {
            self.latitude = location.latitude
            self.longitude = location.longitude
        } else {
            self.latitude = nil
            self.longitude = nil
        }
        
        self.$account.id = newTransaction.account
    }
}
