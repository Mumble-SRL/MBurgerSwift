//
//  MBUploadableTextElement.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import MBNetworkingSwift

/// An uploadable element representing the text.
public struct MBUploadableTextElement: MBUplodableElementProtocol {
    public var localeIdentifier: String
    
    public var elementName: String
    
    /// The text of the element.
    public let text: String
    
    /// Initializes a text element with the name, the locale and a text.
    /// - Parameters:
    ///   - elementName: The name/key of the element.
    ///   - localeIdentifier: The locale of the element.
    ///   - text: The text of the element.
    init(elementName: String, localeIdentifier: String, text: String) {
        self.localeIdentifier = localeIdentifier
        self.elementName = elementName
        self.text = text
    }
    
    public func toForm() -> [MBMultipartForm]? {
        guard let data = text.data(using: .utf8) else { return nil }
        return [MBMultipartForm(name: parameterName, data: data)]
    }
}
