//
//  MasterViewController.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import UIKit

class RepositoriesListViewController: UITableViewController {

    var coordinator: RepositoriesListCoordinator?
    var dataSource: RepositoriesDataSource? = RepositoriesDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        coordinator?.start()
    }


}

extension RepositoriesListViewController: CoordinatorDelegate {
    
    func update() {
        guard let coordinator = coordinator else {
            fatalError()
        }
        dataSource?.repositories = coordinator.repositories
        tableView.reloadData()
    }
    
}

