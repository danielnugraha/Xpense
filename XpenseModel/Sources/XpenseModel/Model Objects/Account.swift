//
//  Account.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 10/11/19.
//  Rewritten by Daniel Nugraha on 08.03.23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: Account
/// Represents a single account that consists of a set of transactions.
@available(iOS 16.0, *)
public struct Account {
    /// The stable identity of the entity associated with self
    public var id: UUID?
    /// The name of the `Account`
    public var name: String
    
    
    /// - Parameters:
    ///   - id: The stable identity of the `Account`
    ///   - name: The name of the `Account`
    public init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
    
    
    /// Finds all transactions that belong to this account.
    /// - Parameters:
    ///     - model: The model to read from
    /// - Returns: All transactions in this account
    public func transactions<M: Model>(_ model: M) -> [Transaction] {
        model.transactions.filter { $0.account == id }
    }
    
    /// Calculates the current balance on this account
    /// - Parameters:
    ///     - model: The model to read from
    /// - Returns: The current balance of this account in cents
    public func balance<M: Model>(_ model: M) -> Transaction.Cent {
        transactions(model).reduce(0) { $0 + $1.amount }
    }
    
    ///  Calculates the current balance on this account and converts it to a human-readable currency format.
    ///  - Parameters:
    ///     - model: The model to read from
    ///  - Returns: The current balance of this account in a human readable form
    public func balanceRepresentation<M: Model>(_ model: M) -> String? {
        NumberFormatter.currencyRepresentation(from: self.balance(model))
    }
}


// MARK: Account: CustomStringConvertible
@available(iOS 16.0, *)
extension Account: CustomStringConvertible {
    public var description: String {
        name
    }
}


// MARK: Account: Identifiable
@available(iOS 16.0, *)
extension Account: Identifiable { }


// MARK: Account: Hashable
@available(iOS 16.0, *)
extension Account: Hashable { }


// MARK: Account: Comparable
@available(iOS 16.0, *)
extension Account: Comparable {
    public static func < (lhs: Account, rhs: Account) -> Bool {
        lhs.name < rhs.name
    }
}

// MARK: Account: Restful
@available(iOS 16.0, *)
extension Account: Restful {
    static let route: URL = RestfulModel.baseURL.appendingPathComponent("accounts")
}
