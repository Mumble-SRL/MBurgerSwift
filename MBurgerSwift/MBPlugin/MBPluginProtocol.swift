//
//  MBPluginProtocol.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 27/09/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

/// A plugin that can be attached to add more functionalities to MBurger.
public protocol MBPluginProtocol: Codable {
    
    /// The key used in the user dictionary, used to retrieve and set the data.
    var userKey: String { get }
    
    /// Returns a object that will be inserted in the pluginsObjects property of the user.
    /// - Parameter response: The response to read data from.
    func object(forUserResponse response: [String: Any]) -> Any?
}
