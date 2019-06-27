//
//  EpisodeListViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 26/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

protocol EpisodeListViewControllerDelegate: class {
    // Se asigna el siguiente nomber de la función por convención:
    // <nombre_del_objeto_que_tiene_un_delegado>(_ <el propio objeto que tiene el delegado>: <clase_del_objeto>,
    // <evento_que_se_comunica> <nombre_objeto_que_se_envia>: <clase_del_objeto>
    //    func houseDetailViewController(_ viewController: HouseDetailViewController, didSelectHouse house: House)
    func episodeListViewController(_ viewController: EpisodeListViewController, didSelectEpisode episode: Episode)
}

final class EpisodeListViewController: UIViewController {

    // MARK: - Properties
    var model: [Episode]
    private let cellId = "EpisodeCell"
    weak var delegate: EpisodeListViewControllerDelegate?

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Inits
    init(model: [Episode]) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = "Episodes"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotifications()
        loadViewIfNeeded()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeOfNotifications()
    }
    
}

extension EpisodeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Obtenemos la seasion que corresponde a la celda
        let episode = model[indexPath.row]
        
        // Creamos la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        // Sincronizamos modelo y vista
        cell.textLabel?.text = episode.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        cell.detailTextLabel?.text = "AirDate: \(dateFormatter.string(from: episode.airDate))"
        
        // Devolvemos la celda
        return cell
    }
}

extension EpisodeListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Averiguar que episodio se ha selecionado
        let episode = model[indexPath.row]

        // Avisamos al delegado
        // Informamos de que se ha seleccionado una casa
        let episodeDetailViewController = EpisodeDetailViewController(model: episode)
        delegate = episodeDetailViewController
        episodeDetailViewController.delegate = self
        delegate?.episodeListViewController(self, didSelectEpisode: episode)
                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension EpisodeListViewController: SeasonDetailViewControllerDelegate {
    func seasonDetailViewController(didSelectEpisodesButton viewController: SeasonDetailViewController) {
        // En este caso no es necesario actualizar el modelo porque este delegado se utiliza cuando se pulsa el botón.
        // Es decir, al hacer click en el botón, es necesario crear un objeto MemberViewController con la casa seleccionada
        viewController.navigationController?.pushViewController(self, animated: true)
    }
}

extension EpisodeListViewController {
    private func subscribeToNotifications() {
        // Nos damos de alta en las notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(seasonDidChange), name: .seasonDidNotificationName, object: nil)
    }
    
    private func unsubscribeOfNotifications() {
        // Nos damos de baja de las notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc private func seasonDidChange(notification: Notification) {
        // Obtener la casa
        guard let dictionary = notification.userInfo else {
            return
        }
        
        // Actualizar modelo
        guard let season = dictionary[SeasonListViewController.Constants.SEASON_KEY] as? Season else {
            return
        }
        
        self.model = season.sortedEpisodes
        
        // Sincronizar modelo y vista
        self.tableView.reloadData()
        // Importante ocultar y mostrar el boton de vuelta atrás de la barra de navegación para que se actualice
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setHidesBackButton(false, animated: false)
    }
}

extension EpisodeListViewController: EpisodeDetailViewControllerDelegate {
    func episodeDetailViewController(_ viewController: EpisodeDetailViewController, didSelectSeason season: Season) {
        self.model = season.sortedEpisodes
        
        // Sincronizar modelo y vista
        self.tableView.reloadData()
        
        // Importante ocultar y mostrar el boton de vuelta atrás de la barra de navegación para que se actualice
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setHidesBackButton(false, animated: false)
        
        // Pop de la vista en el NavigationController
        viewController.navigationController?.popViewController(animated: true)

    }
    
    
}
