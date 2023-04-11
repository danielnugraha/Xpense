//
//  XpenseServiceError.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2023 TUM LS1. All rights reserved.
//

import Foundation

// MARK: XpenseServiceError
/// An `Error` that details possible errors that can occur when interacting with Xpense Server
public enum XpenseServiceError: Error {
    /// Use this error in case the decoding of a message from the server failed
    case loginFailed
    /// Use this error in case the sign up process failed
    case signUpFailed
    /// Use this error if saving a resource on the Xpense Server failed
    case loadingFailed(Codable.Type)
    /// Use this error if an unknown and unexpected error occurred
    case saveFailed(Codable.Type)
    /// Use this error if deleting a resource on the Xpense Server failed
    case deleteFailed(Codable.Type)
    /// Use this error if the user token seems to have expired and the user needs to login again
    case unknown
    
    public var localizedDescription: String {
        // swiftlint:disable line_length
        switch self {
        case .loginFailed:
            return """
                The login failed.
                Please make sure that you are connected to the internet, signed up, and the credentials are correct.
            """
        case .signUpFailed:
            return """
                Could not sign up.
                Please make sure that you are connected to the internet or choose an other name, the name seems to be taken.
            """
        case let .loadingFailed(type):
            return """
                Could not load the \(type.self)s from the Xpense Server.
                Please make sure that you are connected to the internet.
                If this error persists try signing out and logging back in.
            """
        case let .saveFailed(type):
            return """
                Could not save the \(type.self) on the Xpense Server.
                Please make sure that you are connected to the internet.
                If this error persists try signing out and logging back in.
            """
        case let .deleteFailed(type):
            return """
                Could not delete the \(type.self) on the Xpense Server.
                Please make sure that you are connected to the internet.
                Make sure there is no data associated to the object you want to delete, e.g. Transactions of an Account.
                If this error persists try signing out and logging back in.
            """
        case .unknown:
            return """
                An unknown error occured.
                Please check your internet connection.
                The Xpense developer did a bad job.
            """
        }
        // swiftlint:enable line_length
    }
}
