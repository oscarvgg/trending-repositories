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
    var remoteDataStore: RemoteDataStore
    var repositories: [Repository] = []
    var currentTerm = "" {
        didSet {
            getRepositories(term: currentTerm, filter: currentFilter)
        }
    }
    var currentFilter: DateFilter = .day
    
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
                    self?.repositories = result.items
                    self?.delegate?.update()
                case .error(let error):
                    // TODO: display error
                    print(error)
                }
        }
    }
}
