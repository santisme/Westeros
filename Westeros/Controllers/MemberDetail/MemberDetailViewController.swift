//
//  MemberDetailViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 09/07/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

class MemberDetailViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var memberNameLabel: UILabel!
    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberAlias: UILabel!
    
    let model: Person
    
    // MARK: - Inits
    init(model: Person) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        syncModelView()
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

// MARK: - Extensions
extension MemberDetailViewController {
    func syncModelView() {
        self.memberNameLabel.text = self.model.name
        self.memberImage.image = self.model.image
        self.memberAlias.text = self.model.alias
    }
}

extension MemberDetailViewController {
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
        navigationController?.popViewController(animated: true)
    }
    
}
