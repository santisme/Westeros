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

        // Creamos un array de casas
        let houses = Repository.local.houses

        // Creamos el controlador
        let houseListController = HouseListViewController(model: houses)
        window?.rootViewController = houseListController.wrappedInNavigation
        
        return true
    }

}

