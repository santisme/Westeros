//
//  HouseListTableViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 18/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class HouseListViewController: UITableViewController {
    
    // MARK: - Properties
    private let model: [House]
    
    
    init(model: [House]) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = "Westeros"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "HouseCell"
        // Descubrir la casa que hay que mostrar
        let house = model[indexPath.row]
        
        // Crear una celda
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .default, reuseIdentifier: cellId)
        
        // Sincronizar modelo House y la vista/celda
        cell.textLabel?.text = house.name
        cell.imageView?.image = house.sigil.image
        
        // Devolver la celda
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Averiguar que casa se ha selecionado
        let house = model[indexPath.row]
        
        // Crear el VC de la casa
        let houseDetailViewController = HouseDetailViewController(house: house)
        
        // Mostrarlo
        navigationController?.pushViewController(houseDetailViewController, animated: true)
        
    }
}
