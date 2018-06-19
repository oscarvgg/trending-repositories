//
//  RepositoriesDelegate.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import TrendingReposData

class RepositoriesDelegate: NSObject, UITableViewDelegate {
    
    var coordinator: RepositoriesListCoordinator
    
    init(coordinator: RepositoriesListCoordinator) {
        self.coordinator = coordinator
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = coordinator.repositories[indexPath.row]
        coordinator.select(repository: repository)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RepositoryTableViewCell else {
            fatalError()
        }
        cell.updateAvatar()
        
        if indexPath.row + 5 >= coordinator.repositories.count && coordinator.canFetchMorePages {
            // increment page
            coordinator.currentResultPage += 1
        }
    }
}
