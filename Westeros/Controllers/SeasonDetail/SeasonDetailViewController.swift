//
//  SeasonDetailViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 26/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

class SeasonDetailViewController: UIViewController {

    // MARK: - Properties
    private var model: Season
    
    
    // MARK: - Outlets
    
    
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// MARK: - Extensions
extension SeasonDetailViewController {
    private func syncModelWithView() {
        loadViewIfNeeded()
        
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
