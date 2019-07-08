//
//  SeasonDetailViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 26/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

protocol SeasonDetailViewControllerDelegate: class {
    // Se asigna el siguiente nomber de la función por convención:
    // <nombre_del_objeto_que_tiene_un_delegado>(_ <el propio objeto que tiene el delegado>: <clase_del_objeto>,
    // <evento_que_se_comunica> <nombre_objeto_que_se_envia>: <clase_del_objeto>
    //    func houseDetailViewController(_ viewController: HouseDetailViewController, didSelectHouse house: House)
    func seasonDetailViewController(didSelectEpisodesButton viewController: SeasonDetailViewController)
}

final class SeasonDetailViewController: UIViewController {

    // MARK: - Properties
    private var model: Season
    weak var delegate: SeasonDetailViewControllerDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - Inits
    init(model: Season) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = model.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        syncModelWithView()
        setupUI()
    }
}

// MARK: - Extensions
extension SeasonDetailViewController {
    private func setupUI() {
        
        let membersButton = UIBarButtonItem(
            title: "Episodes",
            style: .plain,
            target: self,                       // Donde está definido el método del action
            action: #selector(displayEpisodes)      // hay que crear un selector que ejecute una función
        )
        // Añadimos el boton al Navigation bar
        navigationItem.rightBarButtonItem = membersButton
        
    }
    
    private func syncModelWithView() {
        loadViewIfNeeded()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.title = self.model.name
        self.nameLabel.text = self.model.name
        self.airDateLabel.text = "AirDate: \(dateFormatter.string(from: self.model.airDate))"
        self.descriptionLabel.text = self.model.description
        self.nameLabel.sizeToFit()
        self.airDateLabel.sizeToFit()
        self.descriptionLabel.sizeToFit()
    }
}


extension SeasonDetailViewController: SeasonListViewControllerDelegate {
    func seasonListViewController(_ viewController: SeasonListViewController, didSelectSeason season: Season) {
        // Actualizamos el modelo
        self.model = season
        
        // Syncronizamos el modelo con la vista
        syncModelWithView()

    }
    
    
}

extension SeasonDetailViewController {
    @objc private func displayEpisodes() {
        // Esta función se tiene que exponer a Objective-C. No se pueden utilizar estructuras y caracteristicas de Swift que no existan en Objective-C
        // Crear el MemberViewController
        let episodeListViewController = EpisodeListViewController(model: model.sortedEpisodes)
        self.delegate = episodeListViewController
        self.delegate?.seasonDetailViewController(didSelectEpisodesButton: self)
    }
}
