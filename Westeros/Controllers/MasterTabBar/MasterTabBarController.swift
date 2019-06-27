//
//  MasterTabBarController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 27/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class MasterTabBarController: UITabBarController {
    // MARK: - Properties
    var houseListViewController: HouseListViewController
    var seasonListViewController: SeasonListViewController
    
    // MARK: - Inits
    init(houseListViewController: HouseListViewController, seasonListViewController: SeasonListViewController) {
        self.houseListViewController = houseListViewController
        self.seasonListViewController = seasonListViewController
        super.init(nibName: nil, bundle: nil)
        syncViewControllers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
//        syncViewControllers()
//        updateSelectedView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
}

// MARK: - Extensions
extension MasterTabBarController {
    private func syncViewControllers() {
        self.viewControllers = [
            houseListViewController.wrappedInNavigation,
            seasonListViewController.wrappedInNavigation
        ]

    }
    
    // Actualiza la DetailView del UISplitViewController dependiendo del valoe selecionado
    private func updateSelectedView() {
        if self.selectedIndex == 1 {
            // Creamos el controlador para SeasonDetail
            let seasonDetailViewController = SeasonDetailViewController(model: seasonListViewController.lastSelectedSeason())
            seasonListViewController.delegate = seasonDetailViewController
            
            splitViewController?.viewControllers = [
                self.wrappedInNavigation,
                seasonDetailViewController.wrappedInNavigation
            ]
            
        } else {
            // Creamos el controlador para HouseDetail
            let houseDetailViewController = HouseDetailViewController(house: houseListViewController.lastSelectedHouse())
            houseListViewController.delegate = houseDetailViewController
            
            splitViewController?.viewControllers = [
                self.wrappedInNavigation,
                houseDetailViewController.wrappedInNavigation
            ]

        }

    }
}

extension MasterTabBarController: UITabBarControllerDelegate {
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Llamamos a la function que actualiza la DetailView del UISplitViewController dependiendo del valoe selecionado
        updateSelectedView()
        syncViewControllers()

    }
    
}

extension MasterTabBarController: UISplitViewControllerDelegate {

    // Con esta función lo que indicamos es que pliegue la vista de detalle y muestre la main en caso de poco tamaño de pantalla
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}
