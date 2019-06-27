//
//  UIViewController+Navigation.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 14/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

// MARK: - UIViewController+Navigation
extension UIViewController {
    var wrappedInNavigation: UINavigationController {
        // IMPORTANTE!!! Esto crea una nueva instancia de UINavigationController
        return UINavigationController(rootViewController: self)
    }

}
