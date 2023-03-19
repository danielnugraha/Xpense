//
//  RestfulModel.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 03/14/20.
//  Rewritten by Daniel Nugraha on 08.03.23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: RestfulModel
/// Handles storing and loading Xpense relevant data from and to a RESTful server.
@available(iOS 16.0, *)
public class RestfulModel: Model {
    /// The base route that is used to access the RESTful server
    static var baseURL: URL = {
        guard let baseURL = URL(string: "http://127.0.0.1:8080/v1/") else {
            fatalError("Coult not create the base URL for the Xpense Server")
        }
        return baseURL
    }()
    
    public override func save(_ account: Account) async {
        await saveElement(account, to: \.accounts)
        await refresh()
    }
    
    public override func save(_ transaction: Transaction) async {
        await saveElement(transaction, to: \.transactions)
        await refresh()
    }
    
    public override func delete(account id: Account.ID) async {
        await delete(id, in: \.accounts)
        await refresh()
    }
    
    public override func delete(transaction id: Transaction.ID) async {
        await delete(id, in: \.transactions)
        await refresh()
    }
    
    public override func signUp(_ name: String, password: String) async {
        await sendSignUpRequest(name, password: password)
        await refresh()
    }

    public override func login(_ name: String, password: String) async {
        await sendLoginRequest(name, password: password)
        await refresh()
    }
    
    /// Sets the `serverError` of the `Model` and returns the error to be processed by `Publishers`
    /// - Parameter error: The `XpenseServiceError` that should be set
    /// - Returns: The `XpenseServiceError` passed in as an argument
    func setServerError(to error: XpenseServiceError) {
        self.serverError = error
    }
    
    /// Refreshes the `Accounts` and `Transaction` in the `Model`
    private func refresh() async {
        do {
            let accounts = try await Account.get()
            DispatchQueue.main.async {
                self.accounts = accounts
            }
        } catch {
            self.setServerError(to:.loadingFailed(Account.self))
        }
        
        do {
            let transactions = try await Transaction.get()
            DispatchQueue.main.async {
                self.transactions = transactions
            }
        } catch {
            self.setServerError(to:.loadingFailed(Transaction.self))
        }
    }
}
