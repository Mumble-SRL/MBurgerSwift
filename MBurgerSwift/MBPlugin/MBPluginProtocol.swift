//
//  MBPluginProtocol.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 27/09/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

public protocol MBPluginProtocol: Codable {
    var userKey: String { get }
    
    func object(forUserResponse response: [String: Any]) -> Any?
}
