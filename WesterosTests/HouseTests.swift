//
//  HouseTests.swift
//  WesterosTests
//
//  Created by Santiago Sanchez merino on 11/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import XCTest
@testable import Westeros

class HouseTests: XCTestCase {

    var starkSigil: Sigil!
    var starkHouse: House!

    var lannisterSigil: Sigil!
    var lannisterHouse: House!

    var arya: Person!
    var robb: Person!
    var tyrion: Person!
    
    override func setUp() {
        starkSigil = Sigil(description: "Warg", image: UIImage())
        lannisterSigil = Sigil(description: "Lion rampant", image: UIImage())
        
        let starkURL = URL(string: "https://awoiaf.westeros.org/index.php/House_Stark")!
        let lannisterURL = URL(string: "https://awoiaf.westeros.org/index.php/House_Lannister")!
        
        starkHouse = House(
            name: "Stark",
            sigil: starkSigil,
            words: "Winter is coming",
            url: starkURL
        )
        
        lannisterHouse = House(
            name: "Lannister",
            sigil: lannisterSigil,
            words: "Hear me roar!",
            url: lannisterURL
        )
        
        arya = Person(name: "Arya", house: starkHouse)
        robb = Person(name: "Robb", house: starkHouse)
        tyrion = Person(name: "Tyrion", house: lannisterHouse)

    }

    override func tearDown() {

    }
    
    func testHouseExistence() {
        XCTAssertNotNil(starkHouse)
    }

    func testSigilExistence() {
        XCTAssertNotNil(starkHouse.sigil)
    }
    
    func testHouseAddMembers() {
        starkHouse.addMember(person: arya)
        XCTAssertEqual(starkHouse.count, 1)
        starkHouse.addMember(person: robb)
        XCTAssertEqual(starkHouse.count, 2)
        starkHouse.addMember(person: robb)
        XCTAssertEqual(starkHouse.count, 2)
        
        lannisterHouse.addMember(person: tyrion)
        XCTAssertEqual(lannisterHouse.count, 1)
        starkHouse.addMember(person: tyrion)
        XCTAssertEqual(starkHouse.count, 2)
        
    }
    
    func testAddPersonsAtOnce() {
        starkHouse.addMember(persons: arya, robb, tyrion)
        XCTAssertEqual(starkHouse.count, 2)
    }
    
    func testHouseConformsToHashable() {
        XCTAssertNotNil(starkHouse.hashValue)
    }
    
    func testHouseEquality() {
        // 1 Igualdad
        XCTAssertEqual(starkHouse, starkHouse)
        
        // 2 Identidad
        let dummyHouse = House(name: "Stark", sigil: starkSigil, words: "Winter is coming", url: URL(string: "https://www.dummy.com")!)
        XCTAssertEqual(starkHouse, dummyHouse)

        // 3 Desigualdad
        XCTAssertNotEqual(starkHouse, lannisterHouse)
    }
    
    func testHouseComparison() {
        XCTAssertLessThan(lannisterHouse, starkHouse)
//        XCTAssertLessThan(starkHouse, lannisterHouse)
    }

    func testHouseSortedMembersReturnsASortedListOfMembers() {
        starkHouse.addMember(persons: robb, arya)
        XCTAssertEqual(starkHouse.count, 2)
        
        XCTAssertEqual(starkHouse.sortedMembers, starkHouse.sortedMembers.sorted())
    }
    
}
