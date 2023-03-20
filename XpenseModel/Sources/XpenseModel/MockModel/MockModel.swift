//
//  MockModel.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 3/14/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: MockModel
/// A `Model` that replaces the content of the Xpense app with a predefined set of elements evey time it is initialized
@available(iOS 16.0, *)
public class MockModel: Model {
    /// Helper function creating a TUM Salary
    private static func createSalary(_ account: UUID) -> Transaction {
        Transaction(id: UUID(),
                    amount: 345678,
                    description: "Salary",
                    date: Date(minutesFromNow: -100000),
                    location: Coordinate(48.148135, 11.566634),
                    account: account)
    }
    
    /// Helper function creating a purchase at the TUM math and informatics building
    private static func createTumFmiPurchase(amount: Int,
                                             description: String,
                                             account: UUID) -> Transaction {
        Transaction(id: UUID(),
                    amount: amount,
                    description: description,
                    date: Date(minutesFromNow: Int.random(in: -60...0)),
                    location: Coordinate(48.262432, 11.667976),
                    account: account)
    }
    
    
    /// Creates a `Model` using mock data for the Xpense Application that resets the information on every application launch
    public convenience init() {
        let paulsWalletId = UUID()
        let paulsWallet = Account(id: paulsWalletId, name: "Paul's Wallet")
        let dorasWalletId = UUID()
        let dorasWallet = Account(id: dorasWalletId, name: "Dora's Wallet")
        let larasWalletId = UUID()
        let larasWallet = Account(id: larasWalletId, name: "Lara's Wallet")
        
        let accounts = [paulsWallet, dorasWallet, larasWallet].sorted()
        
        let transactions = [
            MockModel.createSalary(paulsWalletId),
            MockModel.createSalary(dorasWalletId),
            MockModel.createSalary(larasWalletId),
            MockModel.createTumFmiPurchase(amount: -490,
                                           description: "Käsespätzle",
                                           account: paulsWalletId),
            MockModel.createTumFmiPurchase(amount: -120,
                                           description: "Spezi",
                                           account: larasWalletId),
            MockModel.createTumFmiPurchase(amount: -100,
                                           description: "Brezn",
                                           account: dorasWalletId),
            MockModel.createTumFmiPurchase(amount: -45,
                                           description: "Obatzda",
                                           account: dorasWalletId),
            Transaction(id: UUID(),
                        amount: -189900,
                        description: "MacBook Air",
                        date: Date(minutesFromNow: -40000),
                        location: Coordinate(37.788687, -122.407173),
                        account: paulsWalletId),
            Transaction(id: UUID(),
                        amount: -269900,
                        description: "MacBook Pro",
                        date: Date(minutesFromNow: -50000),
                        location: Coordinate(40.763844, -73.972965),
                        account: dorasWalletId),
            Transaction(id: UUID(),
                        amount: -114900,
                        description: "iPhone 11 Pro",
                        date: Date(minutesFromNow: -3600),
                        location: Coordinate(37.332792, -122.005349),
                        account: larasWalletId)
        ].sorted()
        
        let user = User(name: "PSchmiedmayer", token: nil)
        
        self.init(user: user, accounts: accounts, transactions: transactions)
    }

    override func loadAccounts() async throws -> [Account] {
        accounts
    }

    override func loadTransactions() async throws -> [Transaction] {
        transactions
    }
}
