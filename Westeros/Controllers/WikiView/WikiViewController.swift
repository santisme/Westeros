//
//  WikiViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 18/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit
import WebKit

final class WikiViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var model: House
    
    // MARK: - Inits
    init(model: House) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self))) // Esta inicialización de bundle funciona esté en el bundle que esté
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Asignar delegados
        webView.navigationDelegate = self
        syncModelWithView()
        
        // Nos suscribimos a notificaciones.
        // Es importante desuscribirnos tan pronto como sea posible ej: viewWillDisappear
        subscribeToNotifications()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Nos desuscribimos de las notificaciones
        unsubscribeOfNotifications()
    }
    
}

extension WikiViewController {
    
    private func syncModelWithView() {
        title = model.name
        navigationItem.title = model.name
        // Importante ocultar y mostrar el boton de vuelta atrás de la barra de navegación para que se actualice
        navigationItem.hidesBackButton = true
        navigationItem.hidesBackButton = false
        webView.isHidden = true
        loadingView.isHidden = false
        loadingView.startAnimating()
        let request = URLRequest(url: model.wikiURL)
        webView.load(request)
    }
}

extension WikiViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Detenemos el loadingView
        loadingView.stopAnimating()
        
        // Ocultamos el loadingView
        loadingView.isHidden = true
        
        // Mostramos la webview
        webView.isHidden = false
    }
    
    // Con esta función del delegado deshabilitamos y habilitamos acciones de navegación
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let type = navigationAction.navigationType
        switch type {
        case .linkActivated, .formSubmitted:
            decisionHandler(.cancel)
        default:
            decisionHandler(.allow)
        }
    }
}

extension WikiViewController {
    private func subscribeToNotifications() {
        // Nos damos de alta en las notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(houseDidChange), name: .houseDidNotificationName, object: nil)
    }
    
    private func unsubscribeOfNotifications() {
        // Nos damos de baja de las notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc private func houseDidChange(notification: Notification) {
        // Obtener la casa
        guard let dictionary = notification.userInfo else {
            return
        }
        
        // Actualizar modelo
        guard let house = dictionary[HouseListViewController.Constants.HOUSE_KEY] as? House else {
            return
        }
        self.model = house
        
        // Sincronizar modelo y vista
        syncModelWithView()
        
    }

}
