//
//  AppDelegate.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 11/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Aquí vamos a lanzar la APP
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .cyan

        // Creamos un array de sesiones
        let seasons = Repository.local.seasons

        // Creamos un array de casas
        let houses = Repository.local.houses

        // Creamos los controladores HouseList y HouseDetail
        let houseListViewController = HouseListViewController(model: houses)
        let houseDetailViewController = HouseDetailViewController(house: houseListViewController.lastSelectedHouse())
        houseListViewController.delegate = houseDetailViewController
        
        // Creamos el controlador para SeasonList y SeasonDetail
        let seasonListViewController = SeasonListViewController(model: seasons)
        let seasonDetailViewController = SeasonDetailViewController(model: seasonListViewController.lastSelectedSeason())
        seasonListViewController.delegate = seasonDetailViewController

        // Creamos un UITabBarController custom
        let tabBarController = MasterTabBarController(houseListViewController: houseListViewController, houseDetailViewController: houseDetailViewController, seasonListViewController: seasonListViewController, seasonDetailViewController: seasonDetailViewController)

        // Creamos el SplitViewController
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [
//            tabBarController.wrappedInNavigation,       // Master
            tabBarController,                            // Master
            tabBarController.houseDetailNavigation,      // Detail
            tabBarController.seasonDetailNavigation      // Detail
        ]

        splitViewController.preferredDisplayMode = .primaryOverlay
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = tabBarController
                
        window?.rootViewController = splitViewController

        return true
    }

}
