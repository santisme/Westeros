//
//  Episode.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 24/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import Foundation

final class Episode {
    // MARK: - Properties
    let title: String
    let airDate: Date
    weak var season: Season?
    
    // MARK: - Inits
    internal init(title: String, airDate: Date, season: Season? = nil) {
        self.title = title
        self.airDate = airDate
        self.season = season
        self.season?.addEpisode(episode: self)
    }
    
}

// MARK: - Extensions
extension Episode: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeAirDate
    }
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try values.decode(String.self, forKey: .title)
        let airDateString = try values.decode(String.self, forKey: .episodeAirDate)
//        let season = try values.decode(Season.self, forKey: .season)

        // Convert String date to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M dd, yyyy"
        let airDate = dateFormatter.date(from: airDateString) ?? Date.init()
//        let seasonNumber = try values.decode(Int.self, forKey: .seasonNumber)

        self.init(title: title, airDate: airDate)

//        let season = Season(number: seasonNumber, name: "Season \(seasonNumber)", airDate: airDate, episode: self)
//        self.season = season
//        self.init(title: title, airDate: airDate, season: season)

    }
    
}

extension Episode: CustomStringConvertible {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let airDateFormatted = dateFormatter.string(from: self.airDate)
        
        var description = String()
        description = "\(airDateFormatted) \(self.title)"
        if self.season?.name != nil {
            description += " \((self.season?.name)!)"
        }

        return description
    }
}

// El protocolo Hashable confirma el protocolo Equatable
// No es necesario crear una nueva extensión para conformar dicho protocolo
extension Episode: Hashable {
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
        hasher.combine(self.airDate)
        hasher.combine(self.season?.name)
    }
}

extension Episode {
    var proxyForComparison: Date {
        return self.airDate
    }
}

extension Episode: Comparable {
    static func < (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.proxyForComparison < rhs.proxyForComparison
    }
}
