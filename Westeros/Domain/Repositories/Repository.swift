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
        let targaryenSigil = Sigil(description: "Three Head Dragon", image: UIImage(named: "targaryen")!)
        let targaryenHouse = House(name: "Targaryen", sigil: targaryenSigil, words: "Fuego y Sangre")

        // Add characters
        let robb = Person(name: "Robb", house: starkHouse, alias: "The young wolf" )
        let arya = Person(name: "Arya", house: starkHouse)
        let tyrion = Person(name: "Tyrion", house: lannisterHouse, alias: "The dwarf")
        let jaime = Person(name: "Jaime", house: lannisterHouse, alias: "The kingslayer")
        let cersei = Person(name: "Cersei", house: lannisterHouse)
        let dani = Person(name: "Daenerys", house: targaryenHouse, alias: "The mother of the dragons")
        
        starkHouse.addMember(person: arya)
        starkHouse.addMember(person: robb)
        lannisterHouse.addMember(person: tyrion)
        lannisterHouse.addMember(person: jaime)
        lannisterHouse.addMember(person: cersei)
        targaryenHouse.addMember(person: dani)
        
        return [starkHouse, lannisterHouse, targaryenHouse].sorted()
    }
}
