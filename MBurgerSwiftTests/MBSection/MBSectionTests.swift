//
//  MBSectionTests.swift
//  MBurgerSwiftTests
//
//  Created by Lorenzo Oliveto on 22/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import XCTest
@testable import MBurgerSwift

class MBSectionTests: XCTestCase {

    func testSection() throws {
        let dictionary = TestUtilities.dictionaryForJson(file: "section")
        let section = MBSection(dictionary)
        
        XCTAssertEqual(section.sectionId, 101)
        XCTAssertEqual(section.order, 1)
        XCTAssertNil(section.elements)
        
        let availableDate = Date(timeIntervalSince1970: 1586526060)

        XCTAssertEqual(section.availableAt, availableDate)
        XCTAssertEqual(section.inEvidence, true)
    }

    func testSectionWithElements() throws {
        let dictionary = TestUtilities.dictionaryForJson(file: "section")
        let section = MBSection(dictionary)
        
        XCTAssertEqual(section.sectionId, 101)
        XCTAssertEqual(section.order, 1)
        XCTAssertNil(section.elements)
        
        let availableDate = Date(timeIntervalSince1970: 1586526060)

        XCTAssertEqual(section.availableAt, availableDate)
        XCTAssertEqual(section.inEvidence, true)
    }

}
