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
    var houseDetailViewController: HouseDetailViewController
    var seasonDetailViewController: SeasonDetailViewController
    var houseListNavigation: UINavigationController
    var seasonListNavigation: UINavigationController
    var houseDetailNavigation: UINavigationController
    var seasonDetailNavigation: UINavigationController
    
    // MARK: - Inits
    init(houseListViewController: HouseListViewController, houseDetailViewController: HouseDetailViewController, seasonListViewController: SeasonListViewController, seasonDetailViewController: SeasonDetailViewController) {
        self.houseListViewController = houseListViewController
        self.seasonListViewController = seasonListViewController
        self.houseDetailViewController = houseDetailViewController
        self.seasonDetailViewController = seasonDetailViewController
        self.houseListNavigation = self.houseListViewController.wrappedInNavigation
        self.seasonListNavigation = self.seasonListViewController.wrappedInNavigation
        self.houseDetailNavigation = self.houseDetailViewController.wrappedInNavigation
        self.seasonDetailNavigation = self.seasonDetailViewController.wrappedInNavigation

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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
}

// MARK: - Extensions
extension MasterTabBarController {
    private func syncViewControllers() {
        self.viewControllers = [
            houseListNavigation,
            seasonListNavigation
        ]

    }
    
    // Actualiza la DetailView del UISplitViewController dependiendo del valoe selecionado
    private func updateSelectedView() {
        
        guard let tabBarNavigation = self.navigationController else {
            fatalError("MasterTabBarController - navigationController is nil")
        }
        
        if self.selectedIndex == 0 {
            
            splitViewController?.viewControllers = [
                tabBarNavigation,
                houseDetailNavigation
            ]

        } else {
            
            splitViewController?.viewControllers = [
                tabBarNavigation,
                seasonDetailNavigation
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
