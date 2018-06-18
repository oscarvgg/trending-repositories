//
//  Entity.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

public protocol Entity: Decodable {
    var identifier: Int? { get set }
}
