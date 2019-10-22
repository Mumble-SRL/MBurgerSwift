//
//  MBDecodable.swift
//  MBurgerSwift
//
//  Created by Alessandro Viviani on 22/10/2019.
//  Copyright © 2019 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import Foundation

public protocol MBDecodable: Decodable {
    init(fromBinary decoder: MBDecoder) throws
}
