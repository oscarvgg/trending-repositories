//
//  SyncDataStore.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 19/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

public final class SyncDataStore {
    
    public var remoteStore: RemoteDataStore
    public var localDataStore: LocalDataStore
    
    public init(remoteStore: RemoteDataStore, localDataStore: LocalDataStore) {
        self.remoteStore = remoteStore
        self.localDataStore = localDataStore
    }
    
    public func getRepositories(withQuery term: String,
                                dateFilter: DateFilterable,
                                onComplete: @escaping (RemoteResult<Page<Repository>>) -> ()) {
        // get the local results first
        localDataStore.getRepositories(
            withQuery: term,
            dateFilter: dateFilter) { [weak self] (localResult) in
                onComplete(localResult)
                // now get the remote ones
                self?.remoteStore.getRepositories(
                    withQuery: term,
                    dateFilter: dateFilter,
                    onComplete: { (remoteResult) in
                        
                        switch remoteResult {
                        case .succeeded(let result):
                            // update local store
                            do {
                                try result.items.forEach({
                                    try self?.localDataStore.save(repository: $0)
                                })
                                // get the results for the remote and local combined
                                self?.localDataStore.getRepositories(
                                    withQuery: term,
                                    dateFilter: dateFilter) { (localResult) in
                                        onComplete(localResult)
                                }
                                
                            } catch let error {
                                onComplete(.error(error))
                            }
                        case .error(let error):
                            onComplete(.error(error))
                        }
                })
        }
    }
}
