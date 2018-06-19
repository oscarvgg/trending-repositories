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
    
    var coordinator: RepositoriesListCoordinator?
    var repository: Repository?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ownerAvatarImageView.layer.cornerRadius = ownerAvatarImageView.bounds.width / 2
        ownerAvatarImageView.clipsToBounds = true
    }
    
    func updateUI() {
        
        if let repository = repository {
            nameLabel.text = "\(repository.owner.username)/\(repository.name)"
            descriptionLabel.text = repository.description ?? "No description"
            favoriteButton.isSelected = repository.isFavorite
            starCountLabel.text = String(repository.starCount)
            return
        }
        ownerAvatarImageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
        favoriteButton.isSelected = false
        starCountLabel.text = nil
    }
    
    func updateAvatar() {
        ownerAvatarImageView.image = nil
        
        guard let avatarURl = repository?.owner.avatarUrl else {
            return
        }
        coordinator?.getAvatar(
            url: avatarURl,
            onComplete: { [weak self] (result) in
                
                switch result {
                case .succeeded(let data):
                    guard let image = UIImage(data: data) else {
                        return
                    }
                    self?.ownerAvatarImageView.image = image
                case .error(_):
                    // TODO: apply default image
                    self?.ownerAvatarImageView.image = nil
                }
        })
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        guard let repository = repository else {
            return
        }
        repository.isFavorite = !repository.isFavorite
        coordinator?.save(repository: repository)
        updateUI()
    }
    
}

extension RepositoryTableViewCell: RepositoryPresentable {
    
    func present(repository: Repository) {
        self.repository = repository
        updateUI()
    }
}
