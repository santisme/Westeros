//
//  EpisodeDetailViewController.swift
//  Westeros
//
//  Created by Santiago Sanchez merino on 26/06/2019.
//  Copyright © 2019 Santiago Sanchez merino. All rights reserved.
//

import UIKit

final class EpisodeDetailViewController: UIViewController {
    // MARK: - Properties
    private var model: Episode
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    // MARK: - Inits
    init(model: Episode) {
        self.model = model
        super.init(nibName: nil, bundle: Bundle(for: type(of: self)))
        title = self.model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        syncModelWithView()
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
extension EpisodeDetailViewController {
    private func syncModelWithView() {
        loadViewIfNeeded()
        self.titleLabel.text = self.model.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        self.airDateLabel.text = "AirDate: \(dateFormatter.string(from: self.model.airDate))"
        self.synopsisLabel.text = self.model.synopsis
    }
}

extension EpisodeDetailViewController {
    private func subscribeToNotifications() {
        // Nos damos de alta en las notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(seasonDidChange), name: .seasonDidNotificationName, object: nil)
    }
    
    private func unsubscribeOfNotifications() {
        // Nos damos de baja de las notificaciones
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc private func seasonDidChange(notification: Notification) {
        navigationController?.popViewController(animated: true)
    }
}
