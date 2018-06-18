//
//  Coordinator.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

protocol Coordinator: class {
    var delegate: CoordinatorDelegate? { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}

protocol CoordinatorDelegate: class {
    func update()
}
