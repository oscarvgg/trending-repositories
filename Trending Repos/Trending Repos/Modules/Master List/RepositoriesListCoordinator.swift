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
    var syncDataStore: SyncDataStore
    var remoteFileStore: RemoteFileStore
    var repositories: [Repository] = []
    
    var currentTerm = "" {
        didSet {
            getRepositories(term: currentTerm, filter: dateFilter)
        }
    }
    
    var mode: RepositoriesListMode = .all {
        didSet {
            getRepositories(term: currentTerm, filter: dateFilter)
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
    
    init(syncDataStore: SyncDataStore,
         remoteFileStore: RemoteFileStore) {
        self.syncDataStore = syncDataStore
        self.remoteFileStore = remoteFileStore
    }
    
    func start() {
        getRepositories(term: currentTerm, filter: dateFilter)
    }
    
    func getRepositories(term: String, filter: DateFilter) {
        
        let resultHandler: (RemoteResult<Page<Repository>>) -> () = { [weak self] (result) in
            
            switch result {
            case .succeeded(let result):
                self?.repositories = result.items
                self?.delegate?.update()
            case .error(let error):
                // TODO: display error
                print(error)
            }
        }
        
        switch mode {
        case .all:
            syncDataStore.getRepositories(
                withQuery: term,
                dateFilter: filter,
                onComplete: resultHandler)
        case .favorites:
            syncDataStore.localDataStore.getRepositories(
                withQuery: term,
                dateFilter: filter,
                isFavorite: true,
                onComplete: resultHandler)
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
    
    func save(repository: Repository) {
        do {
            try syncDataStore.localDataStore.save(repository: repository, shouldUpdateFavorite: true)
            
        } catch let error {
            print(error)
        }
    }
}

protocol RepositoriesListCoordinatorDelegate: class {
    func didSelectRepository(_ repository: Repository)
}
