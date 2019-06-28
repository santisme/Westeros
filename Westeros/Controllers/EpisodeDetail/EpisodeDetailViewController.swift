//
//  EpisodeDetailViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 26/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

protocol EpisodeDetailViewControllerDelegate: class {
    // Se asigna el siguiente nomber de la función por convención:
    // <nombre_del_objeto_que_tiene_un_delegado>(_ <el propio objeto que tiene el delegado>: <clase_del_objeto>,
    // <evento_que_se_comunica> <nombre_objeto_que_se_envia>: <clase_del_objeto>
    //    func houseDetailViewController(_ viewController: HouseDetailViewController, didSelectHouse house: House)
    func episodeDetailViewController(_ viewController: EpisodeDetailViewController, didSelectSeason season: Season)
}


final class EpisodeDetailViewController: UIViewController {
    // MARK: - Properties
    private var model: Episode
    weak var delegate: EpisodeDetailViewControllerDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    // MARK: - Inits
    init(model: Episode) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = self.model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeOfNotifications()
    }
}

// MARK: - Extensions
extension EpisodeDetailViewController {
    private func syncModelWithView() {
        loadViewIfNeeded()
        self.titleLabel.text = self.model.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.airDateLabel.text = "AirDate: \(dateFormatter.string(from: self.model.airDate))"
        self.synopsisLabel.text = self.model.synopsis
//        self.titleLabel.sizeToFit()
//        self.airDateLabel.sizeToFit()
    }
}

extension EpisodeDetailViewController: EpisodeListViewControllerDelegate {
    func episodeListViewController(_ viewController: EpisodeListViewController, didSelectEpisode episode: Episode) {
        // Actualizamos el modelo
        self.model = episode
        
        // Syncronizamos el modelo con la vista
        syncModelWithView()
        viewController.navigationController?.pushViewController(self, animated: true)

    }
    
}

extension EpisodeDetailViewController {
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

        delegate?.episodeDetailViewController(self, didSelectSeason: season)
//        navigationController?.popViewController(animated: true)

    }
}
