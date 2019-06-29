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
    var img: String?
    let synopsis: String
    weak var season: Season?
    
    // MARK: - Inits
    internal init(title: String, airDate: Date, img: String? = nil, synopsis: String, season: Season? = nil) {
        self.title = title
        self.airDate = airDate
        self.img = img
        self.synopsis = synopsis
        self.season = season
        self.season?.addEpisode(episode: self)
    }
    
}

// MARK: - Extensions
extension Episode: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeAirDate
        case img
        case synopsis
    }
    
    convenience init(from decoder: Decoder) throws {
        let imgUrlPrefix = "http://assets.viewers-guide.hbo.com/large"
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        let title = try values.decode(String.self, forKey: .title)
        let airDateString = try values.decode(String.self, forKey: .episodeAirDate)
        var img = try values.decodeIfPresent(String.self, forKey: .img)
        let synopsis = try values.decode(String.self, forKey: .synopsis)

        // Convert String date to Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M dd, yyyy"
        let airDate = dateFormatter.date(from: airDateString) ?? Date.init()

        if img == nil {
            self.init(title: title, airDate: airDate, synopsis: synopsis)
        } else {
            img = imgUrlPrefix + img!
            self.init(title: title, airDate: airDate, img: img, synopsis: synopsis)
        }
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
