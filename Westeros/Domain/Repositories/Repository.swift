//
//  Repository.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 14/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class Repository {
    static let local = LocalFactory()
}

protocol HouseFactory {
    var houses: [House] { get }
}

final class LocalFactory: HouseFactory {
    var houses: [House] {
        let starkSigil = Sigil(description: "Warg", image: UIImage(named: "stark")!)
        let starkHouse = House(name: "Stark", sigil: starkSigil, words: "Winter is coming")
        let lannisterSigil = Sigil(description: "Lion rampant", image: UIImage(named: "lannister")!)
        let lannisterHouse = House(name: "Lannister", sigil: lannisterSigil, words: "Hear me roar!")
        
        return [starkHouse, lannisterHouse]
    }
}
