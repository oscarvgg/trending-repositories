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
    
    public var isLoading = false
    private var coreDataManager = CoreDataManager(modelName: "TrendingRepos")
    
    public init() {}
    
    public func getRepositories(withQuery term: String,
                                dateFilter: DateFilterable,
                                isFavorite: Bool = false,
                                page: Int = 0,
                                pageSize: Int = 20,
                                onComplete: @escaping (RemoteResult<Page<Repository>>) -> ()) {
        isLoading = true
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
        
        // request the total page count
        var totalCount = 0
            
        do {
            let resultCount = try coreDataManager.managedObjectContext.count(for: fetchRequest)
            totalCount = Int(ceilf(Float(resultCount) / Float(pageSize)))
        }
        catch let error {
            print(error)
        }
        
        // limits
        fetchRequest.fetchLimit = pageSize
        fetchRequest.fetchOffset = pageSize * page
        
        coreDataManager.managedObjectContext.perform { [weak self] in
             do {
                self?.isLoading = false
                let localRepositories = try fetchRequest.execute()
                
                let repositories = localRepositories.map({ (localRepo) -> Repository in
                    return Repository(managedObject: localRepo)
                })
                
                let page = Page<Repository>()
                page.totalCount = totalCount
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
