//
//  Person.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 12/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class Person {
    let name: String
    unowned let house: House
    var alias: String?
    let image: UIImage

    init(name: String, house: House, alias: String? = "", image: UIImage) {
        self.name = name
        self.house = house
        self.alias = alias
        self.image = image
        house.addMember(person: self)
    }
}

extension Person: Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

extension Person: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
        hasher.combine(self.house)
        hasher.combine(self.alias)
    }
}

extension Person {
    var proxyForComparison: String {
        return name.uppercased()
    }
}

extension Person: Comparable {
    static func < (lhs: Person, rhs: Person) -> Bool {
        return lhs.proxyForComparison < rhs.proxyForComparison
    }
}

extension Person {
    var fullName: String {
        return "\(self.name) \(self.house.name)"
    }
}
