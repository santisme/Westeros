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
    private let model: [Person]
    
    // MARK: - Inits
    init(model: [Person]) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = "Members"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

// Conformar el controlador al protocolo delegate y datasource
extension MemberListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "PersonCell"
        
        // Obtenemos la persona que corresponde a la celda
        let person = model[indexPath.row]
        
        // Creamos la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        // Sincronizamos modelo y vista
        cell.textLabel?.text = person.fullName
        cell.detailTextLabel?.text = person.alias
        
        // Devolvemos la celda
        return cell
    }
    
}
