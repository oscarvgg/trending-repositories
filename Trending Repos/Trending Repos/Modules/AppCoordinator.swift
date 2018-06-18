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
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    func start() {
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = .allVisible
        
        guard let masterVC = splitViewController.viewControllers.first as? UINavigationController, let masterListVC = masterVC.viewControllers.first as? RepositoriesListViewController else {
            fatalError()
        }
        
        let masterCoordinator = RepositoriesListCoordinator(remoteDataStore: RemoteDataStore())
        childCoordinators.append(masterCoordinator)
        masterCoordinator.delegate = masterListVC
        masterListVC.coordinator = masterCoordinator
        masterCoordinator.delegate?.update()
        masterCoordinator.listDelegate = self
    }
    
}


extension AppCoordinator: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}

extension AppCoordinator: RepositoriesListCoordinatorDelegate {
    
    func didSelectRepository(_ repository: Repository) {
        print("selected \(repository.name)")
    }
}
