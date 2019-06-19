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
    
    func house(named name: String) -> House?
    func houses(filteredBy theFilter: (House) -> Bool) -> [House]

}

final class LocalFactory: HouseFactory {
    var houses: [House] {
        let starkSigil = Sigil(description: "Warg", image: UIImage(named: "stark")!)
        let lannisterSigil = Sigil(description: "Lion rampant", image: UIImage(named: "lannister")!)
        let targaryenSigil = Sigil(description: "Three Head Dragon", image: UIImage(named: "targaryen")!)

        let starkURL = URL(string: "https://awoiaf.westeros.org/index.php/House_Stark")!
        let lannisterURL = URL(string: "https://awoiaf.westeros.org/index.php/House_Lannister")!
        let targaryenURL = URL(string: "https://awoiaf.westeros.org/index.php/House_Targaryen")!

        let starkHouse = House(
            name: "Stark",
            sigil: starkSigil,
            words: "Winter is coming",
            url: starkURL
        )
        let lannisterHouse = House(
            name: "Lannister",
            sigil: lannisterSigil,
            words: "Hear me roar!",
            url: lannisterURL
        )
        let targaryenHouse = House(
            name: "Targaryen",
            sigil: targaryenSigil,
            words: "Fire and Blood",
            url: targaryenURL
        )

        // Add characters
        let robb = Person(name: "Robb", house: starkHouse, alias: "The young wolf", image: UIImage(named: "robb")!)
        let arya = Person(name: "Arya", house: starkHouse, image: UIImage(named: "arya")!)
        let tyrion = Person(name: "Tyrion", house: lannisterHouse, alias: "The dwarf", image: UIImage(named: "tyrion")!)
        let jaime = Person(name: "Jaime", house: lannisterHouse, alias: "The kingslayer", image: UIImage(named: "jamie")!)
        let cersei = Person(name: "Cersei", house: lannisterHouse, image: UIImage(named: "cersei")!)
        let dani = Person(name: "Daenerys", house: targaryenHouse, alias: "The mother of the dragons", image: UIImage(named: "danaerys")!)
 
        starkHouse.addMember(persons: arya, robb)
        lannisterHouse.addMember(persons: tyrion, jaime, cersei)
        targaryenHouse.addMember(person: dani)
        
        return [starkHouse, lannisterHouse, targaryenHouse].sorted()
    }
    
    func house(named name: String) -> House? {
        return houses.first { $0.name.uppercased() == name.uppercased() } // filter + first
    }
    
    func houses(filteredBy theFilter: (House) -> Bool) -> [House] {
        return houses.filter(theFilter)
    }
}
