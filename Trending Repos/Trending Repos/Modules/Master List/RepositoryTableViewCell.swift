//
//  RepositoryTableViewCell.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 19/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import UIKit
import TrendingReposData

class RepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var starCountLabel: UILabel!
    
    var repository: Repository?
    
    func updateUI() {
        
        if let repository = repository {
            nameLabel.text = "\(repository.owner.username)/\(repository.name)"
            descriptionLabel.text = repository.description ?? "No description"
            favoriteButton.isSelected = repository.isFavorite
            starCountLabel.text = String(repository.starCount)
            return
        }
        
        nameLabel.text = nil
        descriptionLabel.text = nil
        favoriteButton.isSelected = false
        starCountLabel.text = nil
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        guard let repository = repository else {
            return
        }
        repository.isFavorite = !repository.isFavorite
        updateUI()
    }
    
}

extension RepositoryTableViewCell: RepositoryPresentable {
    
    func present(repository: Repository) {
        self.repository = repository
        updateUI()
    }
}
