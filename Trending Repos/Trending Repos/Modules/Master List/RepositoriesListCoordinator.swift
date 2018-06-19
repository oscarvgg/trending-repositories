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
    var remoteFileStore: RemoteFileStore
    fileprivate var allRepositories: [Repository] = []
    var filteredRepositories: [Repository] = []
    
    var currentTerm = "" {
        didSet {
            getRepositories(term: currentTerm, filter: dateFilter)
        }
    }
    
    var mode: RepositoriesListMode = .all {
        didSet {
            applyLocalFilters()
        }
    }
    
    var dateFilter: DateFilter = .day {
        didSet {
            getRepositories(term: currentTerm, filter: dateFilter)
        }
    }
    
    enum RepositoriesListMode {
        case all
        case favorites
    }
    
    init(remoteDataStore: RemoteDataStore, remoteFileStore: RemoteFileStore) {
        self.remoteDataStore = remoteDataStore
        self.remoteFileStore = remoteFileStore
    }
    
    func start() {
        getRepositories(term: currentTerm, filter: dateFilter)
    }
    
    func getRepositories(term: String, filter: DateFilter) {
        remoteDataStore.getRepositories(
            withQuery: term,
            dateFilter: filter) { [weak self] (result) in
                
                switch result {
                case .succeeded(let result):
                    self?.allRepositories = result.items
                    self?.applyLocalFilters()
                case .error(let error):
                    // TODO: display error
                    print(error)
                }
        }
    }
    
    func getAvatar(url: String, onComplete: @escaping (RemoteResult<Data>) -> ()) {
        guard let url = URL(string: url) else {
            return onComplete(.error(AppError.invalidUrl))
        }
        
        remoteFileStore.get(url: url) { (result) in
            onComplete(result)
        }
    }
    
    func select(repository: Repository) {
        listDelegate?.didSelectRepository(repository)
    }
    
    func applyLocalFilters() {
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
