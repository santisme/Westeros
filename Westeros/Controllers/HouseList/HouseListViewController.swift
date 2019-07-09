//
//  HouseListTableViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 18/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

// Con class solo lo pueden conformar clases o reference types
protocol HouseListViewControllerDelegate: class {
    // Should
    // Will
    // Did
    // Se asigna el siguiente nomber de la función por convención:
    // <nombre_del_objeto_que_tiene_un_delegado>(_ <el propio objeto que tiene el delegado>: <clase_del_objeto>,
    // <evento_que_se_comunica> <nombre_objeto_que_se_envia>: <clase_del_objeto>
    func houseListViewController(_ viewController: HouseListViewController, didSelectHouse house: House)
}

final class HouseListViewController: UITableViewController {
    
    // MARK: - Properties
    private let model: [House]
    // Se declara la variable delegate. Si apunta a una clase, siempre debe ser weak para que no cuente en ARC
    weak var delegate: HouseListViewControllerDelegate?
    private let houseColor = [
        "stark": [UIColor.lightGray, UIColor.black],
        "lannister": [UIColor(red: 0.35, green: 0.074, blue: 0.054, alpha: 1.0), UIColor.white],
        "targaryen": [UIColor.black, UIColor.white]
    ]
    
    enum Constants {
        static let HOUSE_KEY = "HouseKey"
        static let LAST_HOUSE_KEY = "LastHouseKey"
    }
    
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
        cell.imageView?.sizeToFit()
        cell.backgroundColor = houseColor[house.name.lowercased()]?[0]
        cell.textLabel?.textColor = houseColor[house.name.lowercased()]?[1]

        // Devolver la celda
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Averiguar que casa se ha selecionado
        let house = model[indexPath.row]

        // Mostramos la detailView del SplitView
        // Obtenemos el DetailViewController del delegado.
        // Esto es necesario porque la selección de la celda se comunica al controlador delegado
        // para que actualice su modelo y vista
        guard let detailViewController = delegate as? HouseDetailViewController,
            // Obtenermos el NavigationController que envuelve el DetailViewController
            let detailNavigationController = detailViewController.navigationController,
            // Mostramos la vista de detalle con el controlador de navegación de detalle
            ((splitViewController?.showDetailViewController(detailNavigationController, sender: nil)) != nil) else {
                let houseDetailViewController = HouseDetailViewController(house: house)
                self.delegate = houseDetailViewController
                navigationController?.show(houseDetailViewController, sender: nil)
                return
        }
        
        // Avisamos al delegado
        // Informamos de que se ha seleccionado una casa
        delegate?.houseListViewController(self, didSelectHouse: house)
        
        // Mandamos la misma información vía Notificaciones
        let notificationCenter = NotificationCenter.default
        let notification = Notification(
            name: .houseDidNotificationName,
            object: self,
            userInfo: [Constants.HOUSE_KEY: house])
        notificationCenter.post(notification)
        
        saveLastelectedHouse(at: indexPath.row)
        
    }
    
}

extension HouseListViewController {
    
    private func saveLastelectedHouse(at index: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(index, forKey: Constants.LAST_HOUSE_KEY)
        userDefaults.synchronize()
    }
    
    func lastSelectedHouse() -> House {
        let userDefaults = UserDefaults.standard
        let lastIndex = userDefaults.integer(forKey: Constants.LAST_HOUSE_KEY)
        
        return model[lastIndex]
    }
}

extension HouseListViewController: HouseListViewControllerDelegate {
    func houseListViewController(_ viewController: HouseListViewController, didSelectHouse house: House) {
        // Actualizamos el modelo
        let houseDetailViewController = HouseDetailViewController(house: house)
        navigationController?.show(houseDetailViewController, sender: nil)
    }
}
