//
//  MemberListViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 19/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class MemberListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak private var tableView: UITableView!
    
    // MARK: - Properties
    private var model: [Person]
    private let cellId = "PersonCell"

    // MARK: - Inits
    init(model: [Person]? = [Person]()) {
        self.model = model!
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = "Members"

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MemberListViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
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

// MARK: - Protocolos
// Conformar el controlador al protocolo delegate y datasource
extension MemberListViewController:  UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Obtenemos la persona que corresponde a la celda
        let person = model[indexPath.row]
        
        // Creamos la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MemberListViewCell
        
        // Sincronizamos modelo y vista
        cell.memberImage?.image = person.image
        cell.memberName?.text = " \(person.name) "
        cell.memberName.sizeToFit()
        if person.alias == "" {
            cell.memberAlias?.text = person.alias
        } else {
            cell.memberAlias?.text = " \(person.alias!) "
        }
        cell.memberAlias.sizeToFit()
        
        // Devolvemos la celda
        return cell
    }
    
}

extension MemberListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation == UIDeviceOrientation.portrait {
            return 200
        } else {
            return 300
        }
    }
}

extension MemberListViewController {
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
        
        self.model = house.sortedMembers
        
        // Sincronizar modelo y vista
        self.tableView.reloadData()
        // Importante ocultar y mostrar el boton de vuelta atrás de la barra de navegación para que se actualice
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.setHidesBackButton(false, animated: false)        
    }
    
}

extension MemberListViewController: HouseDetailControllerDelegate {
    func didSelectButton(_ viewController: HouseDetailViewController) {
        // En este caso no es necesario actualizar el modelo porque este delegado se utiliza cuando se pulsa el botón.
        // Es decir, al hacer click en el botón, es necesario crear un objeto MemberViewController con la casa seleccionada
        viewController.navigationController?.pushViewController(self, animated: true)
    }
}
