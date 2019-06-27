//
//  SeasonListViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 26/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

protocol SeasonListViewControllerDelegate: class {
    // Se asigna el siguiente nomber de la función por convención:
    // <nombre_del_objeto_que_tiene_un_delegado>(_ <el propio objeto que tiene el delegado>: <clase_del_objeto>,
    // <evento_que_se_comunica> <nombre_objeto_que_se_envia>: <clase_del_objeto>
    //    func houseDetailViewController(_ viewController: HouseDetailViewController, didSelectHouse house: House)
    func seasonListViewController(_ viewController: SeasonListViewController, didSelectSeason season: Season)
}

final class SeasonListViewController: UIViewController {
    // MARK: - Properties
    private var model: [Season]
    private let cellId = "SeasonCell"
    weak var delegate: SeasonListViewControllerDelegate?
    
    enum Constants {
        static let SEASON_KEY = "SeasonKey"
        static let LAST_SEASON_KEY = "LastSeasonKey"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Inits
    init(model: [Season]? = [Season]()) {
        self.model = model!
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = "Seasons"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
}

extension SeasonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Obtenemos la seasion que corresponde a la celda
        let season = model[indexPath.row]
        
        // Creamos la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        // Sincronizamos modelo y vista
        cell.textLabel?.text = season.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.detailTextLabel?.text = "AirDate: \(dateFormatter.string(from: season.airDate))"
        
        // Devolvemos la celda
        return cell
    }
}

extension SeasonListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Averiguar que casa se ha selecionado
        let season = model[indexPath.row]
        
        // Mostramos la detailView del SplitView
        // Obtenemos el DetailViewController del delegado.
        // Esto es necesario porque la selección de la celda se comunica al controlador delegado
        // para que actualice su modelo y vista
        guard let detailViewController = delegate as? SeasonDetailViewController,
            // Obtenermos el NavigationController que envuelve el DetailViewController
            let detailNavigationController = detailViewController.navigationController,
            // Mostramos la vista de detalle con el controlador de navegación de detalle
            ((splitViewController?.showDetailViewController(detailNavigationController, sender: nil)) != nil) else {
                fatalError("SeasonListViewController - delegate is nil")
        }
        
        // Avisamos al delegado
        // Informamos de que se ha seleccionado una casa
        delegate?.seasonListViewController(self, didSelectSeason: season)
        
        // Mandamos la misma información vía Notificaciones
        let notificationCenter = NotificationCenter.default
        let notification = Notification(
            name: .seasonDidNotificationName,
            object: self,
            userInfo: [Constants.SEASON_KEY: season])
        notificationCenter.post(notification)
        
        saveLastelectedSeason(at: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension SeasonListViewController {
    
    private func saveLastelectedSeason(at index: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(index, forKey: Constants.LAST_SEASON_KEY)
        userDefaults.synchronize()
    }
    
    func lastSelectedSeason() -> Season {
        let userDefaults = UserDefaults.standard
        let lastIndex = userDefaults.integer(forKey: Constants.LAST_SEASON_KEY)
        
        return model[lastIndex]
    }
}
