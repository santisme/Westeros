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

        // Creamos el controlador
        let houseListViewController = HouseListViewController(model: houses)
        let houseDetailViewController = HouseDetailViewController(house: houseListViewController.lastSelectedHouse())
        houseListViewController.delegate = houseDetailViewController
        
        // Los envolvemos en Navigation controller
//        let masterNavigation = houseListViewController.wrappedInNavigation
//        let detailNavigation = houseDetailViewController.wrappedInNavigation

        
        // Creamos el controlador
        let seasonListViewController = SeasonListViewController(model: seasons)
        let seasonDetailViewController = SeasonDetailViewController(model: seasonListViewController.lastSelectedSeason())
        seasonListViewController.delegate = seasonDetailViewController
        
        // Los envolvemos en Navigation controller
        let masterNavigation = seasonListViewController.wrappedInNavigation
        let detailNavigation = seasonDetailViewController.wrappedInNavigation

        
        // Creamos el SplitViewController
        let splitViewController = UISplitViewController()
        splitViewController.viewControllers = [
            masterNavigation,    // Master
            detailNavigation   // Detail
        ]

        splitViewController.preferredDisplayMode = .primaryOverlay
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = seasonListViewController

//        splitViewController.delegate = houseListViewController
        window?.rootViewController = splitViewController
        
        return true
    }

}
