//
//  HouseDetailViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 13/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

// Con class solo lo pueden conformar clases o reference types
protocol HouseDetailViewControllerDelegate: class {
    // Should
    // Will
    // Did
    // Se asigna el siguiente nomber de la función por convención:
    // <nombre_del_objeto_que_tiene_un_delegado>(_ <el propio objeto que tiene el delegado>: <clase_del_objeto>,
    // <evento_que_se_comunica> <nombre_objeto_que_se_envia>: <clase_del_objeto>
//    func houseDetailViewController(_ viewController: HouseDetailViewController, didSelectHouse house: House)
    func didSelectButton(_ viewController: HouseDetailViewController)

}

final class HouseDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var sigilImageView: UIImageView!
    @IBOutlet weak var wordsLabel: UILabel!
    
    // MARK: - Properties
    var house: House
    // Se declara la variable delegate. Si apunta a una clase, siempre debe ser weak para que no cuente en ARC
    weak var delegate: HouseDetailViewControllerDelegate?
    
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
        // Importante cuando implementamos un UISplitViewController
        // Es necesario cargar la vista en caso de que no se encuentre visible
        // cuando la pantalla es pequeña
        loadViewIfNeeded()
        self.title = house.name
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
        
        let membersButton = UIBarButtonItem(
            title: "Members",
            style: .plain,
            target: self,                       // Donde está definido el método del action
            action: #selector(displayMembers)      // hay que crear un selector que ejecute una función
        )
        // Añadimos el boton al Navigation bar
        navigationItem.rightBarButtonItems = [wikiButton, membersButton]

    }
    
    @objc private func displayWiki() {
        // Esta función se tiene que exponer a Objective-C. No se pueden utilizar estructuras y caracteristicas de Swift que no existan en Objective-C
        // Crear el wiki WC
        let wikiViewController = WikiViewController(model: house)
        self.delegate = wikiViewController
        self.delegate?.didSelectButton(self)
        
    }
    
    @objc private func displayMembers() {
        // Esta función se tiene que exponer a Objective-C. No se pueden utilizar estructuras y caracteristicas de Swift que no existan en Objective-C
        // Crear el MemberViewController
        let memberListViewController = MemberListViewController(model: house.sortedMembers)
        self.delegate = memberListViewController
        self.delegate?.didSelectButton(self)

    }

}

extension HouseDetailViewController: HouseListViewControllerDelegate {
    func houseListViewController(_ viewController: HouseListViewController, didSelectHouse house: House) {
        // Actualizamos el modelo
        self.house = house
        
        // Syncronizamos el modelo con la vista
        syncModelWithView()
        
    }
}

