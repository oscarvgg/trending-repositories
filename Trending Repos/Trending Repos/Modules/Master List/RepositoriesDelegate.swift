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
    
    var repositories: [Repository] = []
    weak var coordinator: RepositoriesListCoordinator?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository = repositories[indexPath.row]
        
        guard let coordinator = coordinator else {
            fatalError()
        }
        
        coordinator.selectRepository(repository)
    }
}
