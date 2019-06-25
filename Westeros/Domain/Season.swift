//
//  Season.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 24/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import Foundation

typealias Episodes = Set<Episode>

final class Season {
    
    // MARK: - Properties
    let number: Int
    let name: String
    let airDate: Date
    private var _episodes: Episodes
    
    // MARK: - Inits
    init(number: Int, name: String, airDate: Date, episode: Episode...) {
        self._episodes = Episodes.init()
        self.number = number
        self.name = name
        self.airDate = airDate
        episode.forEach {
            self.addEpisode(episode: $0)
        }
    }
}

// MARK: - Extensions
extension Season: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case seasonNumber
        case seasonAirDate
        case episodes
//        case title
//        case episodeAirDate
    }
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let seasonNumber = try values.decode(Int.self, forKey: .seasonNumber)
        let seasonAirDateString = try values.decode(String.self, forKey: .seasonAirDate)
        let episodes = try values.decode([Episode].self, forKey: .episodes)
//        let title = try values.decode(String.self, forKey: .title)
//        let episodeAirDateString = try values.decode(String.self, forKey: .episodeAirDate)
        
        // Convert String dates to Dates
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M dd, yyyy"
        let seasonAirDate = dateFormatter.date(from: seasonAirDateString) ?? Date.init()
//        let episodeAirDate = dateFormatter.date(from: episodeAirDateString) ?? Date.init()
        
        // Call to Season class init
        self.init(number: seasonNumber, name: "Season \(seasonNumber)", airDate: seasonAirDate, episode: episodes.first!)
        episodes.forEach {
            self.addEpisode(episode: $0)
        }

    }
}

extension Season {
    func episodeCount() -> Int {
        return self._episodes.count
    }
    
    func addEpisode(episode: Episode) {
        // Si la temporada es nil, asignamos al episodio esta temporada
        if episode.season == nil {
            episode.season = self
        }
        
        // Si la temporada coincide con la temporada del episodio
        if self.number == episode.season?.number {
            self._episodes.insert(episode)
            
        }
    }
    
    var sortedEpisodes: [Episode] {
        return _episodes.sorted()
    }
    
}

extension Season: CustomStringConvertible {
    var description: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let airDateFormatted = dateFormatter.string(from: self.airDate)
        let description = "\(airDateFormatted) \(self.name)"
        return description
    }
}

// El protocolo Hashable confirma el protocolo Equatable
// No es necesario crear una nueva extensión para conformar dicho protocolo
extension Season: Hashable {
    static func == (lhs: Season, rhs: Season) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.number)
        hasher.combine(self.name)
        hasher.combine(self.airDate)
    }
}

extension Season {
    var proxyForComparison: Date {
        return self.airDate
    }
}

extension Season: Comparable {
    static func < (lhs: Season, rhs: Season) -> Bool {
        return lhs.proxyForComparison < rhs.proxyForComparison
    }
}

