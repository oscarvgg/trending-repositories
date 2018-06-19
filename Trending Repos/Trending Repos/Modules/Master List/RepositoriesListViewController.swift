//
//  MasterViewController.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import UIKit

class RepositoriesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var coordinator: RepositoriesListCoordinator? {
        didSet {
            coordinator?.delegate = self
            delegate.coordinator = coordinator
            searchDelegate = SearchDelegate(coordinator: coordinator!)
            searchBar.delegate = searchDelegate
            coordinator?.start()
        }
    }
    
    var dataSource = RepositoriesDataSource()
    var searchDelegate: SearchDelegate?
    var delegate = RepositoriesDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[0]
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func changeDateFilter(_ sender: Any) {
        guard let dateFilter = DateFilter(rawValue:
            segmentedControl.selectedSegmentIndex) else {
                fatalError()
        }
        coordinator?.dateFilter = dateFilter
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetail",
            let indexPath = tableView.indexPathForSelectedRow,
            let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
                
        let detailVC = (segue.destination as! UINavigationController).topViewController as! DetailViewController
        
        let appCoordinator = appDelegate.appCoordinator!
        let repository = coordinator?.filteredRepositories[indexPath.row]
        
        appCoordinator.childCoordinators = appCoordinator.childCoordinators.filter({ (coordinator) -> Bool in
            detailVC.coordinator !== coordinator
        })
        
        let detailCoordinator = DetailCoordinator()
        detailCoordinator.repository = repository
        appCoordinator.childCoordinators.append(detailCoordinator)
        detailVC.coordinator = detailCoordinator
    }
    
}

extension RepositoriesListViewController: CoordinatorDelegate {
    
    func update() {
        guard let coordinator = coordinator else {
            fatalError()
        }
        dataSource.repositories = coordinator.filteredRepositories
        delegate.repositories = coordinator.filteredRepositories
        tableView.reloadData()
    }
    
}

extension RepositoriesListViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(where: { $0 === item }) else {
            fatalError()
        }
        switch index {
        case 0:
            coordinator?.mode = .all
        case 1:
            coordinator?.mode = .favorites
        default:
            fatalError()
        }
    }
}

