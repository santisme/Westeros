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
    func house(named: LocalFactory.Names) -> House?
    
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
        let _ = Person(name: "Robb", house: starkHouse, alias: "The young wolf", image: UIImage(named: "robb")!)
        let _ = Person(name: "Arya", house: starkHouse, image: UIImage(named: "arya")!)
        let _ = Person(name: "Tyrion", house: lannisterHouse, alias: "The dwarf", image: UIImage(named: "tyrion")!)
        let _ = Person(name: "Jaime", house: lannisterHouse, alias: "The kingslayer", image: UIImage(named: "jamie")!)
        let _ = Person(name: "Cersei", house: lannisterHouse, image: UIImage(named: "cersei")!)
        let _ = Person(name: "Daenerys", house: targaryenHouse, alias: "The mother of the dragons", image: UIImage(named: "danaerys")!)
        
        return [starkHouse, lannisterHouse, targaryenHouse].sorted()
    }
    
    func house(named name: String) -> House? {
        return houses.first { $0.name.uppercased() == name.uppercased() } // filter + first
    }
    
    func houses(filteredBy theFilter: (House) -> Bool) -> [House] {
        return houses.filter(theFilter)
    }
    
    func house(named: LocalFactory.Names) -> House? {
        return houses(filteredBy: { (house) -> Bool in
            house.name == named.rawValue
        }).first
    }

}

protocol SeasonFactory {
    var seasons: [Season] { get }
    func seasons(filteredBy theFilter: (Season) -> Bool) -> [Season]
    
}

extension LocalFactory: SeasonFactory {
    //    https://5cb8efd61551570014da43e7.mockapi.io/seasons
    var seasons: [Season] {
        var seasonList = [Season]()
        let remoteURLString = "https://5cb8efd61551570014da43e7.mockapi.io/seasons"
        let remoteURL = URL(string: remoteURLString)
        
        do {
            let remoteStringList = try String(contentsOf: remoteURL!)
            let remoteJson = remoteStringList.data(using: .utf8)
            let jsonDecoder = JSONDecoder()
            seasonList = try jsonDecoder.decode([Season].self, from: remoteJson!)
        } catch {

            do {
                let remoteStringList = localHouseListJsonString
                let remoteJson = remoteStringList.data(using: .utf8)
                let jsonDecoder = JSONDecoder()
                seasonList = try jsonDecoder.decode([Season].self, from: remoteJson!)
            } catch {
                print("Unexpected Error")
            }
        }
        
        return seasonList.sorted()
    }
    
    func seasons(filteredBy theFilter: (Season) -> Bool) -> [Season] {
        return seasons.filter(theFilter)
    }
}


extension LocalFactory {
    public enum Names: String {
        case Stark
        case Lannister
        case Targaryen
    }
}

extension LocalFactory {
    var localHouseListJsonString: String {
        return """
        [{"seasonNumber": 1,    "seasonAirDate": "April 17, 2011",    "episodes": [{"episodeNumber": 1,    "title": "Winter Is Coming",    "episodeAirDate": "April 17, 2011", "synopsis": "King Robert Baratheon with Queen Cersei Lannister and the entire family arrives in Winterfell. They offer Ned Stark to be the Hand of the King. On the other side of the narrow sea, we see the story of the Targaryens. Viserys Targaryen trades his sister, Daenerys Targaryen to the Dothraki leader as a wife. In exchange, he wants the Dothraki army to take back the Iron Throne. In Winterfell, Ned’s youngest son Bran Stark finds out the Cersei and Jaime (her brother) are involved sexually. So, to keep this a secret Jaime pushes Bran out of the window." },
        {"episodeNumber": 2,    "title": "The Kingsroad",    "episodeAirDate": "April 24, 2011", "synopsis": "Bran goes into a coma after the great fall. His mother, Catelyn Stark, doubts that this was a murderous attempt by one of the Lannisters. By then, Ned has to leave for King’s Landing to honour his new position as the Hand of the King. But, Catelyn does not want Ned to leave. Arya and Sansa join Ned. On the other hand, Jon Snow (Ned’s bastard son) also leaves for The Night’s Watch. The Night’s Watch is an army of men who watch over a giant ice wall. This wall separates the seven kingdoms from the white walkers and the wildlings. Tyrion Lannister (Cersei’s other brother) also joins Jon Snow to his journey to the Wall. Also during a misunderstanding, Arya’s pet direwolf bites Prince Joffrey and flees. Hence, as a punishment, Ned kills Sansa Stark’s direwolf. Meanwhile, Daenerys gets married to Khal Drogo and focuses on how to please her new husband." },
        {"episodeNumber": 3,    "title": "Lord Snow",    "episodeAirDate": "May 1, 2011", "synopsis": "Ned reaches King’s Landing and realizes that the management system in Westeros in terrible. Bran learns that he will never be able to walk again and Catelyn is heartbroken because of this. She goes to King’s Landing to alert Ned about the intentions of the Lannisters. Catelyn meets Lord Baelish (Littlefinger) on the way. She also discovers that the knife which was found in the tower following Bran’s fall, belonged to Tyrion. Arya starts learning swordsmanship. And Jon Snow has a hard time to make his mark in Castle Black. Meanwhile, Daenerys finds out that she is pregnant." },
        {"episodeNumber": 4,    "title": "Cripples, Bastards, and Broken Things",    "episodeAirDate": "May 8, 2011", "synopsis": "Ned tries to investigate the death of the previous Hand of the King, Jon Arryn. During that, he meets one of Robert’s bastard sons, Gendry. A tournament is held in KIng’s Landing to celebrate Ned’s appointment. Tyrion returns to Winterfell to hire more men for the Night’s Watch. But he finds out that he is the main suspect for Bran’s condition. Hence, he gets captured by Catelyn Stark under the suspicion of an attempted murder of Bran. Sansa starts falling in love with Joffrey and imagines her life as a queen. On the other hand, Viserys becomes impatient with the Dothraki army as he needs them to invade Westeros as soon as possible." },
        {"episodeNumber": 5,    "title": "The Wolf and the Lion",    "episodeAirDate": "May 15, 2011", "synopsis": "Catelyn Stark and the bannermen are attacked by savages while transporting Tyrion for trial. Tyrion ends up saving Catelyn’s life by killing a man with a shield. He is the taken to the Eyrie, to Catelyn’s sister, Lysa. In King’s Landing, Arya finds out about an impending war and Tyrion’s arrest through Lord Varys. Ned gets attacked by Jaime because of his alleged involvement in Tyrion’s arrest. Robert comes to know about Daenerys’ alliance with the Dothrakis and plans for an attack. This drives a rift in his relationship with Ned." },
        {"episodeNumber": 6,    "title": "A Golden Crown",    "episodeAirDate": "May 22, 2011", "synopsis": "Tyrion somehow manages to get a trial by combat. His victory would ensure his freedom. So, he hires a mercenary named Bronn as his champion. Bronn ultimately wins and Tyrion becomes a free man. Ned finally learns about the reason for Jon Arryn’s death. It was Arryn’s discovery of Joffrey being Jaime’s son, not Robert’s. Meanwhile, Dany proves her worth to the Dothraki by devouring a horse’s heart. Viserys gets jealous of the attention that she is getting and threatens her. Khal Drogo gives him a crown made of molten lead which ultimately kills him." },
        {"episodeNumber": 7,    "title": "You Win or You Die",    "episodeAirDate": "May 29, 2011", "synopsis": "King Robert Baratheon return from his hunt, wounded and ultimately dies. Joffrey is crowned as the king. Ned confronts Cersei about Joffrey’s secret. He reveals this information to the council. But, he gets betrayed and gets jailed. Daenerys is rescued by an attack by Jorah Mormont. She and the Dothraki army pledge to get revenge and reclaim the throne." },
        {"episodeNumber": 8,    "title": "The Pointy End",    "episodeAirDate": "June 5, 2011", "synopsis": "Back at the great Wall, Jon Snow finds the bodies of two men who had gone missing for days. Yet, their bodies had not decomposed. At night, one of the corpses come back to life and only dies when Jon Snow lights it on fire. Everyone suspects that the white walkers had returned. In King’s Landing, the Lannisters plan to capture the Stark girls. Sansa gives in but Arya manages to escape. Cersei informs Sansa that Ned has to offer his loyalty to Joffrey or else he will be executed." },
        {"episodeNumber": 9,    "title": "Baelor",    "episodeAirDate": "June 12, 2011", "synopsis": "Khal Drogo becomes incredibly sick and becomes infected. She seeks the help of a witch who could heal him by blood magic. In King’s Landing, Ned is compelled to pledge his loyalty to Joffrey in front of the kingdom. However, Joffrey’s tyrannical behaviour gets the best of him and he goes back on his word. Ned is beheaded in front of everyone and this leaves his daughters in shock." },
        {"episodeNumber": 10,    "title": "Fire and Blood",    "episodeAirDate": "June 19, 2011", "synopsis": "Ned Stark’s death causes a lot of chaos in the North. It declares Robb Stark as the King in the North. Arya goes into hiding as a boy named Harry with The Hound. Sansa is still bound in King’s Landing at the Lannisters’ mercy. Also, Tyrion becomes the Hand of the King who needs to keep Joffrey’s behaviour in check. Meanwhile, the blood magic of the witch kills Daenerys’ unborn child in an attempt to revive Khal Drogo. She of course fails to do that. In a fit of rage, she ties the witch to Drogo’s funeral pyre and sets it on fire. She then walks into the pyre with the three dragon eggs. When the fire dies out, she walks out of it, unharmed and with three baby dragons." }]},
        {"seasonNumber": 2,    "seasonAirDate": "April 1, 2012",    "episodes": [{"episodeNumber": 1,    "title": "The North Remembers",    "episodeAirDate": "April 1, 2012", "synopsis": "" },
        {"episodeNumber": 2,    "title": "The Night Lands",    "episodeAirDate": "April 8, 2012", "synopsis": "" },
        {"episodeNumber": 3,    "title": "What Is Dead May Never Die",    "episodeAirDate": "April 15, 2012", "synopsis": "" },
        {"episodeNumber": 4,    "title": "Garden of Bones",    "episodeAirDate": "April 22, 2012", "synopsis": "" },
        {"episodeNumber": 5,    "title": "The Ghost of Harrenhal",    "episodeAirDate": "April 29, 2012", "synopsis": "" },
        {"episodeNumber": 6,    "title": "The Old Gods and the New",    "episodeAirDate": "May 6, 2012", "synopsis": "" },
        {"episodeNumber": 7,    "title": "A Man Without Honor",    "episodeAirDate": "May 13, 2012", "synopsis": "" },
        {"episodeNumber": 8,    "title": "The Prince of Winterfell",    "episodeAirDate": "May 20, 2012", "synopsis": "" },
        {"episodeNumber": 9,    "title": "Blackwater",    "episodeAirDate": "May 27, 2012", "synopsis": "" },
        {"episodeNumber": 10,    "title": "Valar Morghulis",    "episodeAirDate": "June 3, 2012", "synopsis": "" }]},
        {"seasonNumber": 3,    "seasonAirDate": "March 31, 2013",    "episodes": [{"episodeNumber": 1,    "title": "Valar Dohaeris",    "episodeAirDate": "March 31, 2013", "synopsis": "" },
        {"episodeNumber": 2,    "title": "Dark Wings, Dark Words",    "episodeAirDate": "April 7, 2013", "synopsis": "" },
        {"episodeNumber": 3,    "title": "Walk of Punishment",    "episodeAirDate": "April 14, 2013", "synopsis": "" },
        {"episodeNumber": 4,    "title": "And Now His Watch Is Ended",    "episodeAirDate": "April 21, 2013", "synopsis": "" },
        {"episodeNumber": 5,    "title": "Kissed by Fire",    "episodeAirDate": "April 28, 2013", "synopsis": "" },
        {"episodeNumber": 6,    "title": "The Climb",    "episodeAirDate": "May 5, 2013", "synopsis": "" },
        {"episodeNumber": 7,    "title": "The Bear and the Maiden Fair",    "episodeAirDate": "May 12, 2013", "synopsis": "" },
        {"episodeNumber": 8,    "title": "Second Sons",    "episodeAirDate": "May 19, 2013", "synopsis": "" },
        {"episodeNumber": 9,    "title": "The Rains of Castamere",    "episodeAirDate": "June 2, 2013", "synopsis": "" },
        {"episodeNumber": 10,    "title": "Mhysa",    "episodeAirDate": "June 9, 2013", "synopsis": "" }]},
        {"seasonNumber": 4,    "seasonAirDate": "April 6, 2014",    "episodes": [{"episodeNumber": 1,    "title": "Two Swords",    "episodeAirDate": "April 6, 2014", "synopsis": "" },
        {"episodeNumber": 2,    "title": "The Lion and the Rose",    "episodeAirDate": "April 13, 2014", "synopsis": "" },
        {"episodeNumber": 3,    "title": "Breaker of Chains",    "episodeAirDate": "April 20, 2014", "synopsis": "" },
        {"episodeNumber": 4,    "title": "Oathkeeper",    "episodeAirDate": "April 27, 2014", "synopsis": "" },
        {"episodeNumber": 5,    "title": "First of His Name",    "episodeAirDate": "May 4, 2014", "synopsis": "" },
        {"episodeNumber": 6,    "title": "The Laws of Gods and Men",    "episodeAirDate": "May 11, 2014", "synopsis": "" },
        {"episodeNumber": 7,    "title": "Mockingbird",    "episodeAirDate": "May 18, 2014", "synopsis": "" },
        {"episodeNumber": 8,    "title": "The Mountain and the Viper",    "episodeAirDate": "June 1, 2014", "synopsis": "" },
        {"episodeNumber": 9,    "title": "The Watchers on the Wall",    "episodeAirDate": "June 8, 2014", "synopsis": "" },
        {"episodeNumber": 10,    "title": "The Children",    "episodeAirDate": "June 15, 2014", "synopsis": "" }]},
        {"seasonNumber": 5,    "seasonAirDate": "April 12, 2015",    "episodes": [{"episodeNumber": 1,    "title": "The Wars to Come",    "episodeAirDate": "April 12, 2015", "synopsis": "" },
        {"episodeNumber": 2,    "title": "The House of Black and White",    "episodeAirDate": "April 19, 2015", "synopsis": "" },
        {"episodeNumber": 3,    "title": "High Sparrow",    "episodeAirDate": "April 26, 2015", "synopsis": "" },
        {"episodeNumber": 4,    "title": "Sons of the Harpy",    "episodeAirDate": "May 3, 2015", "synopsis": "" },
        {"episodeNumber": 5,    "title": "Kill the Boy",    "episodeAirDate": "May 10, 2015", "synopsis": "" },
        {"episodeNumber": 6,    "title": "Unbowed, Unbent, Unbroken",    "episodeAirDate": "May 17, 2015", "synopsis": "" },
        {"episodeNumber": 7,    "title": "The Gift",    "episodeAirDate": "May 24, 2015", "synopsis": "" },
        {"episodeNumber": 8,    "title": "Hardhome",    "episodeAirDate": "May 31, 2015", "synopsis": "" },
        {"episodeNumber": 9,    "title": "The Dance of Dragons",    "episodeAirDate": "June 7, 2015", "synopsis": "" },
        {"episodeNumber": 10,    "title": "Mother's Mercy",    "episodeAirDate": "June 14, 2015", "synopsis": "" }]},
        {"seasonNumber": 6,    "seasonAirDate": "April 24, 2016",    "episodes": [{"episodeNumber": 1,    "title": "The Red Woman",    "episodeAirDate": "April 24, 2016", "synopsis": "" },
        {"episodeNumber": 2,    "title": "Home",    "episodeAirDate": "May 1, 2016", "synopsis": "" },
        {"episodeNumber": 3,    "title": "Oathbreaker",    "episodeAirDate": "May 8, 2016", "synopsis": "" },
        {"episodeNumber": 4,    "title": "Book of the Stranger",    "episodeAirDate": "May 15, 2016", "synopsis": "" },
        {"episodeNumber": 5,    "title": "The Door",    "episodeAirDate": "May 22, 2016", "synopsis": "" },
        {"episodeNumber": 6,    "title": "Blood of My Blood",    "episodeAirDate": "May 29, 2016", "synopsis": "" },
        {"episodeNumber": 7,    "title": "The Broken Man",    "episodeAirDate": "June 5, 2016", "synopsis": "" },
        {"episodeNumber": 8,    "title": "No One",    "episodeAirDate": "June 12, 2016", "synopsis": "" },
        {"episodeNumber": 9,    "title": "Battle of the Bastards",    "episodeAirDate": "June 19, 2016", "synopsis": "" },
        {"episodeNumber": 10,    "title": "The Winds of Winter",    "episodeAirDate": "June 26, 2016", "synopsis": "" }]},
        {"seasonNumber": 7,    "seasonAirDate": "July 16, 2017",    "episodes": [{"episodeNumber": 1,    "title": "Dragonstone",    "episodeAirDate": "July 16, 2017", "synopsis": "" },
        {"episodeNumber": 2,    "title": "Stormborn",    "episodeAirDate": "July 23, 2017", "synopsis": "" },
        {"episodeNumber": 3,    "title": "The Queen's Justice",    "episodeAirDate": "July 30, 2017", "synopsis": "" },
        {"episodeNumber": 4,    "title": "The Spoils of War",    "episodeAirDate": "August 6, 2017", "synopsis": "" },
        {"episodeNumber": 5,    "title": "Eastwatch",    "episodeAirDate": "August 13, 2017", "synopsis": "" },
        {"episodeNumber": 6,    "title": "Beyond the Wall",    "episodeAirDate": "August 20, 2017", "synopsis": "" },
        {"episodeNumber": 7,    "title": "The Dragon and the Wolf",    "episodeAirDate": "August 27, 2017", "synopsis": "" }]},
        {"seasonNumber": 8,    "seasonAirDate": "April 14, 2019",    "episodes": [{"episodeNumber": 1,    "title": "Winterfell",    "episodeAirDate": "April 14, 2019", "synopsis": "" },
        {"episodeNumber": 2,    "title": "A Knight of the Seven Kingdoms",    "episodeAirDate": "April 21, 2019", "synopsis": "" },
        {"episodeNumber": 3,    "title": "The Long Night",    "episodeAirDate": "April 28, 2019", "synopsis": "" },
        {"episodeNumber": 4,    "title": "The Last of the Starks",    "episodeAirDate": "May 5, 2019", "synopsis": "" },
        {"episodeNumber": 5,    "title": "The Bells",    "episodeAirDate": "May 12, 2019", "synopsis": "" },
        {"episodeNumber": 6,    "title": "The Iron Throne",    "episodeAirDate": "May 19, 2019", "synopsis": "" }]}]
        """
    }
    
}
