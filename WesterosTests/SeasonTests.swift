//
//  SeasonTests.swift
//  WesterosTests
//
//  Created by Santiago Sanchez merino on 24/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import XCTest
@testable import Westeros

class SeasonTests: XCTestCase {

    var dateFormatter: DateFormatter!
    var airDate: Date!
    var season1: Season!
    var season2: Season!
    var episode1: Episode!
    var episode2: Episode!

    override func setUp() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        airDate = dateFormatter.date(from: "17.04.2011") ?? Date.init()
        season1 = Season(number: 1, name: "Season 1", airDate:  airDate, episode: Episode(title: "Winter is coming", airDate: airDate))
        airDate = dateFormatter.date(from: "24.04.2011") ?? Date.init()
        season2 = Season(number: 1, name: "Season 2", airDate:  airDate, episode: Episode(title: "The kingsroad", airDate: airDate))

        episode1 = Episode(title: "Winter is coming", airDate: airDate, season: season1)
        episode2 = Episode(title: "The kingsroad", airDate: airDate, season: season2)
    }

    override func tearDown() {

    }

    func testSeasonExistence() {
        XCTAssertNotNil(season1)
    }
    
    func testSeasonAirDateCheck() {
        airDate = dateFormatter.date(from: "17.04.2011") ?? Date.init()
        XCTAssertEqual(dateFormatter.string(from: airDate), "17.04.2011")
        
        airDate = dateFormatter.date(from: "01.05.2019") ?? Date.init()
        XCTAssertEqual(dateFormatter.string(from: airDate), "01.05.2019")
        
    }
    
    func testSeasonConformsCustomStringConvertible() {
        XCTAssertNotNil(season1.description)
        XCTAssertEqual(season1.description, "17.04.2011 Season 1")
        XCTAssertEqual(season2.description, "24.04.2011 Season 2")
        
    }
    
    func testSeasonConformsEquatable() {
        // Test Equality
        XCTAssertEqual(season1, season1)
        
        // Test Identity
        airDate = dateFormatter.date(from: "17.04.2011") ?? Date.init()
        let seasonDummy = Season(number: 1, name: "Season 1", airDate:  airDate, episode: Episode(title: "Winter is coming", airDate: airDate))
        XCTAssertEqual(season1, seasonDummy)
        
        // Test Not Equality
        XCTAssertNotEqual(season1, season2)
        
    }
    
    func testSeasonConformsToHashable() {
        XCTAssertNotNil(season1.hashValue)
    }
    
    func testSeasonConformsComparable() {
        XCTAssertLessThan(season1, season2)
        XCTAssertLessThanOrEqual(season1, season2)
        XCTAssertGreaterThan(season2, season1)
    }
    
    func testSeasonEpisodesCount() {
        XCTAssertEqual(season1.episodeCount() , 2)
        XCTAssertEqual(season2.episodeCount() , 1)
    }
    
    func testSeasonSortedEpisodesReturnsASortedListOfEpisodes() {
        XCTAssertEqual(season1.sortedEpisodes, season1.sortedEpisodes.sorted())
    }
}
