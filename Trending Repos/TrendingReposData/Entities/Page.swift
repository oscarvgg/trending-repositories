//
//  Page.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation


public final class Page<T: Entity>: Decodable {
    public var totalCount: Int = 0
    public var items: [T] = []
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
