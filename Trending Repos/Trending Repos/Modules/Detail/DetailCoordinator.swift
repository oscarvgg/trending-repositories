//
//  RepositoryCoordinator.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import TrendingReposData

class DetailCoordinator: Coordinator {
    
    var repository: Repository?
    
    var delegate: CoordinatorDelegate?
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        delegate?.update()
    }
    
}
