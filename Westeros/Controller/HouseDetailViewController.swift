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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        syncModelWithView()
        setupUI()
    }

}

extension HouseDetailViewController {
    private func syncModelWithView() {
        houseNameLabel.text = "House \(house.name)"
        sigilImageView.image = house.sigil.image
        wordsLabel.text = house.words
    }
}

extension HouseDetailViewController {
    private func setupUI() {
        let wikiButton = UIBarButtonItem(
            title: "Wiki",
            style: .plain,
            target: self,                       // Donde está definido el método del action
            action: #selector(displayWiki)      // hay que crear un selector que ejecute una función
        )
        
        // Añadimos el boton al Navigation bar
        navigationItem.rightBarButtonItem = wikiButton
    }
    
    @objc private func displayWiki() {          // Esta función se tiene que exponer a Objective-C. No se pueden utilizar estructuras y caracteristicas de Swift que no existan en Objective-C
        // Crear el wiki WC
        let wikiViewController = WikiViewController(model: house)
        
        // Mostrarlo mediante un push navigation controller
        navigationController?.pushViewController(wikiViewController, animated: true)
        
    }
}
