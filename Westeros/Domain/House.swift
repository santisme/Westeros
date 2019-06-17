//
//  House.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 11/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

typealias Words = String
typealias Members = Set<Person>

final class House {

    let name: String
    let sigil: Sigil
    let words: Words
    private var _members: Members
    
    init(name: String, sigil: Sigil, words: Words) {
        self.name = name
        self.sigil = sigil
        self.words = words
        _members = Members.init()
    }
    
}

extension House {
    var count: Int {
        return _members.count
    }

    func addMember(person: Person) {
        if (self == person.house) {
            _members.insert(person)
        }
    }
    
    func addMember(persons: Person...) {
        persons.forEach{ addMember(person: $0)}
    }
}

extension House: Equatable {
    static func == (lhs: House, rhs: House) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension House: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.sigil.description)
    }
    
}

extension House {
    var proxyForComparison: String {
//        return name.uppercased().count
        return name.uppercased()
    }

}

extension House: Comparable {
    static func < (lhs: House, rhs: House) -> Bool {
        // alguna lógica para definir cuándo el lhs < rhs
        return lhs.proxyForComparison < rhs.proxyForComparison
    }
    
}
