//
//  TestUtilities.swift
//  MBurgerSwiftTests
//
//  Created by Lorenzo Oliveto on 20/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//
import Foundation

class TestUtilities {
    static func dictionaryForJson(file: String, checkBody: Bool = true) -> [String: AnyHashable] {
        let bundle = Bundle(for: TestUtilities.self)
        let url = bundle.url(forResource: file, withExtension: ".json")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
            fatalError("Couldn't read data.json file")
        }

        let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        guard let dictionary = obj as? [String: AnyHashable] else {
            fatalError("JSON is not a dictionary")
        }
        if !checkBody {
            return dictionary
        }
        guard let body = dictionary["body"] as? [String: AnyHashable] else {
            fatalError("Body is not present")
        }
        return body
    }
}
