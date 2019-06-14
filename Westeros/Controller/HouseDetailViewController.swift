//
//  HouseDetailViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 13/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class HouseDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var sigilImageView: UIImageView!
    @IBOutlet weak var wordsLabel: UILabel!
    
    // MARK: - Properties
    var starkSigil: Sigil!
    var starkHouse: House!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        starkSigil = Sigil(description: "Warg", image: UIImage(named: "stark")!)
        starkHouse = House(name: "Stark", sigil: starkSigil, words: "Winter is coming")
        houseNameLabel.text = starkHouse.name
        sigilImageView.image = starkSigil.image
        wordsLabel.text = starkHouse.words
    }

}
