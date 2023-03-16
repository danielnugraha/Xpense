//
//  SignUpMediator.swift
//  Xpense
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: SignUpMediator
/// A mediator to interface with the Xpense Server sign up process
struct SignUpMediator: Codable {
    /// The name of the `User` that is send to and returned from the sign up process
    var name: String
    /// The password of the `User` that is send to the Xpense Server
    var password: String?
}
