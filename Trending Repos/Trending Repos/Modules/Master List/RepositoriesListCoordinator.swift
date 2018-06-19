//
//  MasterListCoordinator.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import TrendingReposData

class RepositoriesListCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var delegate: CoordinatorDelegate? = nil
    weak var listDelegate: RepositoriesListCoordinatorDelegate? = nil
    var remoteDataStore: RemoteDataStore
    fileprivate var allRepositories: [Repository] = []
    var filteredRepositories: [Repository] = []
    var currentTerm = "" {
        didSet {
            getRepositories(term: currentTerm, filter: currentFilter)
        }
    }
    var mode: RepositoriesListMode = .all {
        didSet {
            applyFilters()
        }
    }
    var currentFilter: DateFilter = .day
    
    enum RepositoriesListMode {
        case all
        case favorites
    }
    
    init(remoteDataStore: RemoteDataStore) {
        self.remoteDataStore = remoteDataStore
    }
    
    func start() {
        getRepositories(term: currentTerm, filter: currentFilter)
    }
    
    func getRepositories(term: String, filter: DateFilter) {
        remoteDataStore.getRepositories(
            withQuery: term,
            dateFilter: filter) { [weak self] (result) in
                
                switch result {
                case .succeeded(let result):
                    self?.allRepositories = result.items
                    self?.applyFilters()
                case .error(let error):
                    // TODO: display error
                    print(error)
                }
        }
    }
    
    func select(repository: Repository) {
        listDelegate?.didSelectRepository(repository)
    }
    
    func applyFilters() {
        var repositories = allRepositories
        
        switch mode {
        case .all:
            filteredRepositories = repositories
        case .favorites:
            filteredRepositories = repositories.filter({ (repo) -> Bool in
                repo.isFavorite == true
            })
        }
        
        delegate?.update()
    }
}

protocol RepositoriesListCoordinatorDelegate: class {
    func didSelectRepository(_ repository: Repository)
}
