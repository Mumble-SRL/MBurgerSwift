//
//  MBPluginProtocol.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 27/09/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

/// Block executed at startup
public typealias ApplicationStartupBlock = (_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?, _ completionBlock: (() -> Void)?) -> Void

/// A plugin that can be attached to add more functionalities to MBurger.
public protocol MBPlugin {
    
    /// The key used in the user dictionary, used to retrieve and set the data.
    var userKey: String? { get }
    
    /// Returns a object that will be inserted in the pluginsObjects property of the user.
    /// - Parameter response: The response to read data from.
    func object(forUserResponse response: [String: Any]) -> Any?
    
    /// Order of the application startup block
    var applicationStartupOrder: Int { get }
    
    /// Application startup block
    func applicationStartupBlock() -> ApplicationStartupBlock?
    
    /// Function called by MBurger when new location data is available, used to synchronize audience location with automated messages
    func locationDataUpdated(latitude: Double, longitude: Double)
}

/// Default values for plugin protocol
public extension MBPlugin {
    
    /// The default value for the user key is nil
    var userKey: String? {
        return nil
    }
    
    /// The default value for the object in user response is nil
    func object(forUserResponse response: [String: Any]) -> Any? {
        return nil
    }
    
    /// Default value for the startup order = -1
    var applicationStartupOrder: Int {
        return -1
    }

    /// Default value for the startup block = nil
    func applicationStartupBlock() -> ApplicationStartupBlock? {
        return nil
    }
    
    /// Default implementation for locationDataUpdated is empty, no action needed
    func locationDataUpdated(latitude: Double, longitude: Double) { }
}
