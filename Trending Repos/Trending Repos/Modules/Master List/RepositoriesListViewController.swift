//
//  MasterViewController.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import UIKit

class RepositoriesListViewController: UITableViewController {

    weak var coordinator: RepositoriesListCoordinator? {
        didSet {
            delegate.coordinator = coordinator
            coordinator?.start()
        }
    }
    var dataSource = RepositoriesDataSource()
    var delegate = RepositoriesDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
    }


}

extension RepositoriesListViewController: CoordinatorDelegate {
    
    func update() {
        guard let coordinator = coordinator else {
            fatalError()
        }
        dataSource.repositories = coordinator.repositories
        delegate.repositories = coordinator.repositories
        tableView.reloadData()
    }
    
}

