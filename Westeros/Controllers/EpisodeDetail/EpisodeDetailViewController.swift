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
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.titleLabel.sizeToFit()
        self.airDateLabel.sizeToFit()
//        self.synopsisLabel.sizeToFit()
    }
}

extension EpisodeDetailViewController: EpisodeListViewControllerDelegate {
    func episodeListViewController(_ viewController: EpisodeListViewController, didSelectEpisode episode: Episode) {
        // Actualizamos el modelo
        self.model = episode
        
        // Syncronizamos el modelo con la vista
        syncModelWithView()
        viewController.navigationController?.pushViewController(self, animated: true)

    }
    
}
