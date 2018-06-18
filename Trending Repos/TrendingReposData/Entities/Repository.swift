//
//  Repository.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

public final class Repository: Entity {
    public var identifier: Int?
    public var name: String
    public var owner: User
    public var description: String?
    public var stars: Int = 0
    public var language: String?
    public var forkCount: Int = 0
    public var createdAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case owner
        case description
        case stars = "stargazers_count"
        case language
        case forkCount = "forks_count"
        case createdAt = "created_at"
    }
    
    init(name: String, owner: User) {
        self.name = name
        self.owner = owner
    }
}
