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
        let dictionary = TestUtilities.dictionaryForJson(file: "project")
        let project = MBProject(dictionary: dictionary)
        
        XCTAssertEqual(project.projectId, 16)
        XCTAssertEqual(project.projectName, "Mumble")
    }

    func testProjectWithContracts() throws {
        let dictionary = TestUtilities.dictionaryForJson(file: "projectContracts")
        let project = MBProject(dictionary: dictionary)
        
        XCTAssertEqual(project.projectId, 16)
        XCTAssertEqual(project.projectName, "Mumble")
        XCTAssertNotNil(project.contracts?.first)
        
        guard let firstContract = project.contracts?.first else {
            fatalError("First contract not present")
        }
        XCTAssertEqual(firstContract.contractId, 1)
        XCTAssertEqual(firstContract.contractName, "Test")
        XCTAssertNotNil(firstContract.link)
        XCTAssertEqual(firstContract.link, "https://www.mburger.cloud")
        XCTAssertNotNil(firstContract.text)
        XCTAssertEqual(firstContract.text, "Lorem ipsum")
        XCTAssert(firstContract.isActive)
        let creationUpdateDate = Date(timeIntervalSince1970: 1595426504)
        XCTAssertEqual(firstContract.creationDate, creationUpdateDate)
        XCTAssertEqual(firstContract.updateDate, creationUpdateDate)
    }

}
