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
    var house: House
    
    // MARK: - Inits
    init(house: House) {
        self.house = house
        super.init(nibName: nil, bundle: nil)
        self.title = house.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        houseNameLabel.text = "House \(house.name)"
        sigilImageView.image = house.sigil.image
        wordsLabel.text = house.words
    }

}
