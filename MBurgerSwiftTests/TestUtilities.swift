//
//  TestUtilities.swift
//  MBurgerSwiftTests
//
//  Created by Lorenzo Oliveto on 20/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//
import Foundation

class TestUtilities {
    static func dictionaryForJson(file: String) -> [String: AnyHashable]? {
        let bunle = Bundle(for: TestUtilities.self)
        let url = bunle.url(forResource: file, withExtension: ".json")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
            fatalError("Couldn't read data.json file")
        }

        let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        return obj as? [String: AnyHashable]
    }
}
