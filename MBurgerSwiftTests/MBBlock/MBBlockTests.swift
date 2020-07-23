//
//  MBBlockTests.swift
//  MBurgerSwiftTests
//
//  Created by Lorenzo Oliveto on 22/07/2020.
//  Copyright © 2020 Mumble S.r.l (https://mumbleideas.it/). All rights reserved.
//

import XCTest
@testable import MBurgerSwift

class MBBlockTests: XCTestCase {
    func testBlock() throws {
        let dictionary = TestUtilities.dictionaryForJson(file: "block")
        let block = MBBlock(dictionary)
        
        XCTAssertEqual(block.blockId, 100)
        XCTAssertEqual(block.title, "Block title")
        XCTAssertEqual(block.subtitle, "Block subtitle")
        XCTAssertEqual(block.order, 1)
        XCTAssertNil(block.sections)
    }

    func testBlockWithSections() throws {
        let dictionary = TestUtilities.dictionaryForJson(file: "blockSections")
        let block = MBBlock(dictionary)
        
        XCTAssertEqual(block.blockId, 100)
        XCTAssertEqual(block.title, "Block title")
        XCTAssertEqual(block.subtitle, "Block subtitle")
        XCTAssertEqual(block.order, 1)
        XCTAssertNotNil(block.sections)
        XCTAssertEqual(block.sections?.count, 1)
    }

    func testBlockWithSectionsAndElements() throws {
        let dictionary = TestUtilities.dictionaryForJson(file: "blockSectionsElements")
        let block = MBBlock(dictionary)
        
        XCTAssertEqual(block.blockId, 100)
        XCTAssertEqual(block.title, "Block title")
        XCTAssertEqual(block.subtitle, "Block subtitle")
        XCTAssertEqual(block.order, 1)
        XCTAssertNotNil(block.sections)
        XCTAssertEqual(block.sections?.count, 1)
        let firstSection = block.sections?[0]
        XCTAssertNotNil(firstSection?.elements)
    }
}
