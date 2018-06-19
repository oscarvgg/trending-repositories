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
    var pageSize = 20
    var hasReachedEnd = false
    
    var isLoading: Bool {
        return syncDataStore.isLoading
    }
    
    var canFetchMorePages: Bool {
        return !isLoading && !hasReachedEnd
    }
    
    var currentResultPage = 0 {
        didSet {
            getRepositories(term: currentTerm, filter: dateFilter)
        }
    }
    
    var currentTerm = "" {
        didSet {
            resetResults()
        }
    }
    
    var mode: RepositoriesListMode = .all {
        didSet {
            resetResults()
        }
    }
    
    var dateFilter: DateFilter = .day {
        didSet {
            resetResults()
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
    
    fileprivate func resetResults() {
        hasReachedEnd = false
        currentResultPage = 0
        repositories = []
        getRepositories(term: currentTerm, filter: dateFilter)
    }
    
    func getRepositories(term: String, filter: DateFilter) {
        
        let resultHandler: (RemoteResult<Page<Repository>>) -> () = { [weak self] (result) in
            self?.updateResults(result: result)
        }
        
        switch mode {
        case .all:
            syncDataStore.getRepositories(
                withQuery: term,
                dateFilter: filter,
                page: currentResultPage,
                pageSize: pageSize,
                onComplete: resultHandler)
        case .favorites:
            syncDataStore.localDataStore.getRepositories(
                withQuery: term,
                dateFilter: filter,
                isFavorite: true,
                page: currentResultPage,
                pageSize: pageSize,
                onComplete: resultHandler)
        }
    }
    
    fileprivate func updateResults(result: RemoteResult<Page<Repository>>) {
        switch result {
        case .succeeded(let result):
            
            if currentResultPage >= (result.totalCount - 1) {
                hasReachedEnd = true
            }
            // avoid duplicates
            var repoSet = Set(repositories)
            repoSet = repoSet.union(result.items)
            // update repo list
            repositories = repoSet.sorted(by: { $0.starCount > $1.starCount })
            delegate?.update()
        case .error(let error):
            // TODO: display error
            print(error)
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
