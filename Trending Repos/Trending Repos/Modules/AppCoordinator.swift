//
//  AppCoordinator.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import TrendingReposData

class AppCoordinator: Coordinator {
    
    let splitViewController: UISplitViewController
    weak var delegate: CoordinatorDelegate?
    var childCoordinators: [Coordinator] = []
    
    var remoteDataStore: RemoteDataStore
    var remoteFileStore: RemoteFileStore
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
        remoteDataStore = RemoteDataStore()
        remoteFileStore = RemoteFileStore()
    }
    
    func start() {
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = .allVisible
        
        guard let masterVC = splitViewController.viewControllers.first as? UINavigationController,
            let masterListVC = masterVC.viewControllers.first as? RepositoriesListViewController,
            let detailNavigationVC = splitViewController.viewControllers[1] as? UINavigationController,
            let detailVC = detailNavigationVC.viewControllers.first as? DetailViewController else {
            fatalError()
        }
        
        let masterCoordinator = RepositoriesListCoordinator(
            remoteDataStore: remoteDataStore,
            remoteFileStore: remoteFileStore)
        childCoordinators.append(masterCoordinator)
        masterListVC.coordinator = masterCoordinator
        masterCoordinator.delegate?.update()
        masterCoordinator.listDelegate = self
        
        let detailCoordinator = DetailCoordinator()
        childCoordinators.append(detailCoordinator)
        detailVC.coordinator = detailCoordinator
    }
    
}


extension AppCoordinator: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }

        if topAsDetailController.coordinator?.repository == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}

extension AppCoordinator: RepositoriesListCoordinatorDelegate {
    
    func didSelectRepository(_ repository: Repository) {
        
        if splitViewController.isCollapsed {
            guard let masterNavigationVC = splitViewController.viewControllers.first as? UINavigationController,
                let master = masterNavigationVC.viewControllers.first as? RepositoriesListViewController else {
                    fatalError()
            }
            master.performSegue(withIdentifier: "showDetail", sender: nil)
            return
        }
        
        
        guard let detailNavigationVC = splitViewController.viewControllers[1] as? UINavigationController,
            let detailVC = detailNavigationVC.viewControllers.first as? DetailViewController else {
                fatalError()
        }
        
        childCoordinators = childCoordinators.filter({ (coordinator) -> Bool in
            detailVC.coordinator !== coordinator
        })
        
        let detailCoordinator = DetailCoordinator()
        detailCoordinator.repository = repository
        childCoordinators.append(detailCoordinator)
        detailVC.coordinator = detailCoordinator
    }
}
