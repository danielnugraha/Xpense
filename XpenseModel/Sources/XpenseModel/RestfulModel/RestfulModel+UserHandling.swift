//
//  RestfulModel+UserHandling.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Rewritten by Daniel Nugraha on 08.03.23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation
import Combine


// MARK: RestfulModel + User Handling
@available(iOS 16.0, *)
extension RestfulModel {
    /// Sends a sign in request to the Xpense Server and parses the corresponding response and updates the `Model`
    /// - Parameters:
    ///   - name: The name that should be used to sign in
    ///   - password: The password that should be used to sign in
    /// - Returns: An `AnyPublisher` that finishes once the sign in resonse arrived and the response was handled
    func sendSignUpRequest(_ name: String, password: String) async {
        let usersRoute = RestfulModel.baseURL.appendingPathComponent("users")
        do {
            _ = try await NetworkManager.postElement(
                SignUpMediator(name: name, password: password),
                on: usersRoute)
            
            await sendLoginRequest(name, password: password)
        } catch {
            self.setServerError(to: .signUpFailed)
        }
    }

    
    /// Sends a login request to the Xpense Server and parses the corresponding response and updates the `Model`
    /// - Parameters:
    ///   - name: The name that should be used to login
    ///   - password: The password that should be used to login
    /// - Returns: An `AnyPublisher` that finishes once the login resonse arrived and the response was handled
    func sendLoginRequest(_ name: String, password: String) async {
        guard let basicAuthToken = "\(name):\(password)".data(using: .utf8)?.base64EncodedString() else {
            self.setServerError(to: .loginFailed)
            return
        }
        do {
            let userToken: User = try await NetworkManager.sendRequest(
                NetworkManager.urlRequest("POST",
                           url: RestfulModel.baseURL.appendingPathComponent("login"),
                           authorization: "Basic \(basicAuthToken)"
                )
            )
            if let bearerToken = userToken.bearerToken {
                NetworkManager.authorization = bearerToken
            }
            
            DispatchQueue.main.async {
                self.user = userToken
            }
        } catch {
            self.setServerError(to: .loginFailed)
        }
    }
}
