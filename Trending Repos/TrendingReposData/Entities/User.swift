//
//  User.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

public final class User: Entity {
    
    public var identifier: Int?
    public var username: String
    public var avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case username = "login"
        case avatarUrl = "avatar_url"
    }
    
    init(username: String) {
        self.username = username
    }
}
