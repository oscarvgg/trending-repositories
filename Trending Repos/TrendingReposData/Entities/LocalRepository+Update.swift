//
//  LocalRepository+Update.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 19/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

extension LocalRepository {
    
    func updateValues(repository: Repository, shouldUpdateFavorite: Bool = false) {
        identifier = Int64(repository.identifier ?? 0)
        name = repository.name
        summary = repository.description
        starCount = Int64(repository.starCount)
        language = repository.language
        forkCount = Int64(repository.forkCount)
        url = repository.url
        createdAt = repository.createdAt
        
        if shouldUpdateFavorite {
            isFavorite = repository.isFavorite
        }
    }
}
