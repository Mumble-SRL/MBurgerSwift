//
//  MBProjectTests.swift
//  MBurgerSwiftTests
//
//  Created by Lorenzo Oliveto on 20/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import XCTest
@testable import MBurgerSwift

class MBProjectTests: XCTestCase {

    func testProject() throws {
        guard let dictionary = TestUtilities.dictionaryForJson(file: "project") else {
            fatalError("Can't decode JSON")
        }
        let project = MBProject(dictionary: dictionary)
        
        XCTAssertEqual(project.projectId, 16)
        XCTAssertEqual(project.projectName, "Mumble")
    }

}
