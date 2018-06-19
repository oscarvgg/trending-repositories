//
//  LocalDataStore.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 19/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import CoreData

public final class LocalDataStore {
    
    private var coreDataManager = CoreDataManager(modelName: "TrendingRepos")
    
    public init() {}
    
    public func getRepositories(withQuery term: String,
                                dateFilter: DateFilterable,
                                isFavorite: Bool = false,
                                onComplete: @escaping (RemoteResult<Page<Repository>>) -> ()) {
        let fetchRequest: NSFetchRequest<LocalRepository> = LocalRepository.fetchRequest()
        
        // create the predicates
        var predicates: [NSPredicate] = []
        
        if term.count > 0 {
            let termPredicate = NSPredicate(format: "name contains[c] %@ AND createdAt > %@", term, dateFilter.date as NSDate)
            predicates.append(termPredicate)
        }
        
        if isFavorite {
            let favoritePredicate = NSPredicate(format: "isFavorite == %@", NSNumber(booleanLiteral: true))
            predicates.append(favoritePredicate)
        }
        
        let datePredicate = NSPredicate(format: "createdAt > %@", dateFilter.date as NSDate)
        predicates.append(datePredicate)
        
        let compoundPredicate = NSCompoundPredicate(
            type: .and,
            subpredicates: predicates)
        
        fetchRequest.predicate = compoundPredicate
        
        // sort descriptors
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(LocalRepository.starCount), ascending: false)
        ]
        
        coreDataManager.managedObjectContext.perform {
            do {
                let localRepositories = try fetchRequest.execute()
                
                let repositories = localRepositories.map({ (localRepo) -> Repository in
                    return Repository(managedObject: localRepo)
                })
                
                let page = Page<Repository>()
                page.items = repositories
                
                DispatchQueue.main.async {
                    onComplete(.succeeded(result: page))
                }
            } catch let error {
                onComplete(.error(error))
            }
        }
    }
    
    public func save(repository: Repository, shouldUpdateFavorite: Bool = false) throws {
        let fetchRequest: NSFetchRequest<LocalRepository> = LocalRepository.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %i", repository.identifier ?? 0)
        
        let fetchedResults = try coreDataManager.managedObjectContext.fetch(fetchRequest)
        
        if let localRepository = fetchedResults.first {
            localRepository.updateValues(repository: repository, shouldUpdateFavorite: shouldUpdateFavorite)
            
        } else {
            let new = repository.managedObject(context: coreDataManager.managedObjectContext)
            coreDataManager.managedObjectContext.insert(new)
        }
        
        
        try coreDataManager.managedObjectContext.save()
    }
    
}
