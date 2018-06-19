//
//  RepositoriesDataSource.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import TrendingReposData

class RepositoriesDataSource: NSObject, UITableViewDataSource {
    
    var coordinator: RepositoriesListCoordinator
    
    init(coordinator: RepositoriesListCoordinator) {
        self.coordinator = coordinator
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordinator.filteredRepositories.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesListViewController
            .ReuseIdentifier
            .repositoryCell.rawValue) as? RepositoryTableViewCell else {
                fatalError("Invalid cell")
        }
        
        let repository = coordinator.filteredRepositories[indexPath.row]
        cell.coordinator = coordinator
        cell.present(repository: repository)
        
        return cell
    }
    
}
