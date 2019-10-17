//
//  MBUploadableCheckboxElement.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import MBNetworking

/// An uploadable element representing a checkbox.
public struct MBUploadableCheckboxElement: MBUplodableElementProtocol {
    public var localeIdentifier: String
    
    public var elementName: String
    
    /// The value of the checkbox.
    public let value: Bool
    
    /// Initializes a checkbox element with the name, the locale and the value.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - value: The value of the checkbox.
    init(elementName: String, localeIdentifier: String, value: Bool) {
        self.elementName = elementName
        self.localeIdentifier = localeIdentifier
        self.value = value
    }
    
    public func toForm() -> [MBMultipartForm]? {
        guard let data = "on".data(using: .utf8), value else { return nil }
        return [MBMultipartForm(name: parameterName, data: data)]
    }
}
