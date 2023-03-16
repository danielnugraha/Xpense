//
//  RestfulModel+Delete.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: RestfulModel + Delete
@available(iOS 16.0, *)
extension RestfulModel {
    /// Deletes an element from a Restful server
    /// - Parameters:
    ///   - id: The id of the element that should be deleted
    ///   - keyPath: The `ReferenceWritableKeyPath` that refers to the collection of `Element`s where the `Element` should be deleted from
    /// - Returns: A `Future` that completes once the resonses from the server have arrived and have been processed
    func delete<Element: Restful>(_ id: Element.ID, in keyPath: ReferenceWritableKeyPath<RestfulModel, [Element]>) async {
        do {
            try await Element.delete(id: id)
            DispatchQueue.main.async {
                self[keyPath: keyPath].removeAll(where: { $0.id == id })
                if !self.path.isEmpty {
                    self.path.removeLast()
                }
            }
        } catch {
            print(error)
            DispatchQueue.main.async {
                self.setServerError(to: .deleteFailed(Element.self))
            }
        }
    }
}
