//
//  EpisodeTests.swift
//  WesterosTests
//
//  Created by Santiago Sanchez merino on 24/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import XCTest
@testable import Westeros

class EpisodeTests: XCTestCase {

    var dateFormatter: DateFormatter!
    var airDate: Date!
    var season: Season!
    var episode1: Episode!
    var episode2: Episode!
    
    override func setUp() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        airDate = dateFormatter.date(from: "17.04.2011") ?? Date.init()
        episode1 = Episode(title: "Winter is coming", airDate: airDate, synopsis: "Episode 1 Synopsis")
        
        airDate = dateFormatter.date(from: "24.04.2011") ?? Date.init()
        season = Season(number: 1, name: "Season 1", airDate: airDate, episode: Episode(title: "The kingsroad", airDate: airDate, synopsis: "Episode 2 Synopsis"))
        episode2 = Episode(title: "The kingsroad", airDate: airDate, synopsis: "Episode 2 Synopsis", season: season)
    }

    override func tearDown() {
    }

    func testAirDateExistence() {
        XCTAssertNotNil(dateFormatter.date(from: "25.12.2018"))
        
    }
    
    func testEpisodeExistence() {
        XCTAssertNotNil(episode1)
        
    }
    
    func testEpisodeAirDateCheck() {
        XCTAssertEqual(dateFormatter.string(from: episode1.airDate), "17.04.2011")
        XCTAssertEqual(dateFormatter.string(from: episode2.airDate), "24.04.2011")

    }
    
    func testEpisodeSynopsisExistence() {
        XCTAssertNotNil(episode1.synopsis)
    }
    
    func testEpisodeConformsCustomStringConvertible() {
        XCTAssertNotNil(episode1.description)
        XCTAssertEqual(episode1.description, "17.04.2011 Winter is coming")
        dump(season)
        XCTAssertEqual(episode2.description, "24.04.2011 The kingsroad Season 1")

    }
    
    func testEpisodeConformsEquatable() {
        // Test Equality
        XCTAssertEqual(episode1, episode1)

        // Test Identity
        airDate = dateFormatter.date(from: "17.04.2011") ?? Date.init()
        var episodeDummy = Episode(title: "Winter is coming", airDate: airDate, synopsis: "Episode 1 Synopsis")
        XCTAssertEqual(episode1, episodeDummy)

        // Test Not Equality
        episodeDummy = Episode(title: "Winter is coming", airDate: airDate, synopsis: "Episode 1 Synopsis", season: season)
        XCTAssertNotEqual(episode1, episodeDummy)

    }
    
    func testEpisodeConformsToHashable() {
        XCTAssertNotNil(episode1.hashValue)
    }
 
    func testEpisodeConformsComparable() {
        XCTAssertLessThan(episode1, episode2)
        XCTAssertLessThanOrEqual(episode1, episode2)
        XCTAssertGreaterThan(episode2, episode1)
    }
}
