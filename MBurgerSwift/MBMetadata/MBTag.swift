//
//  MBTag.swift
//  MBurgerSwift
//
//  Created by Lorenzo Oliveto on 09/04/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import UIKit

class MBTag: NSObject {
    @objc let key: String!
    @objc let value: String!
    
    @objc init(key: String, value: String!) {
        self.key = key
        self.value = value
    }
}
