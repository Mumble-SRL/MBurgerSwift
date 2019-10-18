//
//  MBUplodableElementProtocol.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 02/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation
import MBNetworkingSwift

/// A protocol to which all MBUploadableElement needs to be conform, it has all the basic data that a MBUplodableElement needs
public protocol MBUplodableElementProtocol {
    /// The locale of the element. This is needed to construct the parameter name.
    var localeIdentifier: String { get }
    
    /// The name/key of the element.
    var elementName: String { get }
    
    /// Converts the element to an array of MBMultipartForm representing it.
    /// - Returns: An optional array of MBMultipartForm objects.
    func toForm() -> [MBMultipartForm]?
}

public extension MBUplodableElementProtocol {
    /// The name of the element, used when the element will be passed to the api.
    var parameterName: String { return String(format: "elements[%@][%@]", localeIdentifier, elementName) }
}
