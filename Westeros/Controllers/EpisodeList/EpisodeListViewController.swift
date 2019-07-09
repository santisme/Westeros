//
//  EpisodeListViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 26/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class EpisodeListViewController: UIViewController {

    // MARK: - Properties
    var model: [Episode]
    private let cellId = "EpisodeCell"

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
    
    deinit {
        // Baja en la notificación
        unsubscribeOfNotifications()
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

        let episodeDetailViewController = EpisodeDetailViewController(model: episode)
        navigationController?.show(episodeDetailViewController, sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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
