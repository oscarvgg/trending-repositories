//
//  Repository.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import CoreData

public final class Repository: Entity {
    public var identifier: Int?
    public var name: String
    public var owner: User
    public var description: String?
    public var starCount: Int = 0
    public var language: String?
    public var forkCount: Int = 0
    public var url: String?
    public var createdAt: Date = Date()
    public var isFavorite = false
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case owner
        case description
        case starCount = "stargazers_count"
        case language
        case forkCount = "forks_count"
        case url = "html_url"
        case createdAt = "created_at"
    }
    
    init(name: String, owner: User) {
        self.name = name
        self.owner = owner
    }
    
    init(managedObject: LocalRepository) {
        identifier = Int(managedObject.identifier)
        name = managedObject.name ?? ""
        owner = User(managedObject: managedObject.owner!)
        description = managedObject.summary
        starCount = Int(managedObject.starCount)
        language = managedObject.language
        forkCount = Int(managedObject.forkCount)
        url = managedObject.url
        createdAt = managedObject.createdAt ?? Date()
        isFavorite = managedObject.isFavorite
    }
    
    func managedObject(context: NSManagedObjectContext) -> LocalRepository {
        let localRepository = LocalRepository(context: context)
        localRepository.identifier = Int64(identifier ?? 0)
        localRepository.name = name
        localRepository.owner = owner.managedObject(context: context)
        localRepository.summary = description
        localRepository.starCount = Int64(starCount)
        localRepository.language = language
        localRepository.forkCount = Int64(forkCount)
        localRepository.url = url
        localRepository.createdAt = createdAt
        localRepository.isFavorite = isFavorite
        
        return localRepository
    }
}
