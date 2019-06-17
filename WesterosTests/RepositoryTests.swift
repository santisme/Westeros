//
//  RepositoryTests.swift
//  WesterosTests
//
//  Created by Santiago Sanchez merino on 14/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import XCTest
@testable import Westeros

class RepositoryTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testHouseRepositoryExistence() {
        XCTAssertNotNil(Repository.local.houses)
    }
    
    func testHouseRepositoryCorrectCount() {
        XCTAssertEqual(Repository.local.houses.count, 3)
    }

    func testLocalRepositoryReturnsSortedArrayOfHouses() {
        let houses = Repository.local.houses
        XCTAssertEqual(houses, houses.sorted())
    }

}
