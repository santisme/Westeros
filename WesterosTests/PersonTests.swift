//
//  PersonTests.swift
//  WesterosTests
//
//  Created by Santiago Sanchez merino on 13/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import XCTest

@testable import Westeros

class PersonTests: XCTestCase {

    var starkSigil: Sigil!
    var starkHouse: House!
    
    var arya: Person!
    var ned: Person!

    
    override func setUp() {
        starkSigil = Sigil(description: "Warg", image: UIImage())
        starkHouse = House(name: "Stark", sigil: starkSigil, words: "Winter is coming")
        
        arya = Person(name: "Arya", house: starkHouse)
        ned = Person(name: "Eddard", house: starkHouse, alias: "Ned")

    }

    override func tearDown() {
    }

    func testPersonExistence() {
        XCTAssertNotNil(ned)
    }

    func testPersonExistenceWithoutAlias() {
        XCTAssertNotNil(arya)
        XCTAssertEqual(arya.alias, "")
    }
    
    func testPersonFullName() {
        XCTAssertEqual(ned.fullName, "Eddard Stark")
    }
    
    func testPersonConformsToHashable() {
        XCTAssertNotNil(ned.hashValue)
    }
    
    func testPersonEquality() {
        // 1 Igualdad
        XCTAssertEqual(ned, ned)
        
        // 2 Identidad
        let dummyPerson = Person(name: "Eddard", house: starkHouse, alias: "Ned")
        XCTAssertEqual(ned, dummyPerson)
        
        // 3 Desigualdad
        XCTAssertNotEqual(ned, arya)
    }
}
