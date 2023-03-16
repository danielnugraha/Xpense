//
//  RestfulModel+Save.swift
//  XpenseModel
//
//  Created by Paul Schmiedmayer on 4/9/20.
//  Rewritten by Daniel Nugraha on 08.03.23.
//  Copyright © 2020 TUM LS1. All rights reserved.
//

import Foundation


// MARK: RestfulModel + Save
@available(iOS 16.0, *)
extension RestfulModel {
    /// Saves an `Restful` element to a RESTful Server
    /// - Parameters:
    ///   - element: The `Restful` element that should be saved
    ///   - collection: The collection where the element should be saved in once a response has arrived
    /// - Returns: A `Future` that completes once the resonses from the server have arrived and have been processed
    func saveElement<Element: Restful>(_ element: Element, to collection: ReferenceWritableKeyPath<RestfulModel, [Element]>) async {
        
        do {
            let newElement: Element
            if self[keyPath: collection].contains(where: { $0.id == element.id }) {
                newElement = try await element.put()
            } else {
                newElement = try await element.post()
            }
            DispatchQueue.main.async {
                self[keyPath: collection].replaceAndSort(newElement)
            }
        } catch {
            DispatchQueue.main.async {
                self.setServerError(to: .saveFailed(Element.self))
            }
        }
    }
}
