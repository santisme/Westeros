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

    func testLocalRepositoryReturnsHouseByNameCaseInsesitive() {
        let stark = Repository.local.house(named: "stark")
        XCTAssertNotNil(stark)

        let lannister = Repository.local.house(named: "LaNNisTer")
        XCTAssertNotNil(lannister)
        
        let keepCoding = Repository.local.house(named: "KeepCoding")
        XCTAssertNil(keepCoding)
    }
    
    func testLocalRepositoryHouseFiltering() {
        // Filtrar aquellas casas cuyos miembros sea solo uno
        var filteredHouses = Repository.local.houses(filteredBy: { $0.count == 1 })
        XCTAssertEqual(filteredHouses.count, 1)

        filteredHouses = Repository.local.houses(filteredBy: { $0.words == "Winter is coming" })
        XCTAssertEqual(filteredHouses.count, 1)
    }
}
