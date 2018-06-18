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
    
    var repositories: [Repository] = []
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepositoriesListViewController
            .ReuseIdentifier
            .repositoryCell.rawValue) else {
                fatalError("Invalid cell")
        }
        
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository.name
        
        return cell
    }
    
}
