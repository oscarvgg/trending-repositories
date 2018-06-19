//
//  RemoteDataStore.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

public protocol DateFilterable {
    var date: Date { get }
}

public enum RemoteResult<T> {
    case succeeded(result: T)
    case error(Error)
}

final public class RemoteDataStore {
    
    var session = URLSession.shared
    public var isLoading = false
    
    public init() {}
    
    public func getRepositories(withQuery term: String,
                         dateFilter: DateFilterable,
                         page: Int = 0,
                         pageSize: Int = 20,
                         onComplete: @escaping (RemoteResult<Page<Repository>>) -> ()) {
        isLoading = true
        var spacedTerm = term
        
        if spacedTerm.count > 0 {
            spacedTerm += " "
        }
        
        let dateString = Formatter.iso8601.string(from: dateFilter.date)
        
        let baseUrlString = "https://api.github.com/search/repositories?q="
        let queryString = "\(spacedTerm)created:>\(dateString)&sort=stars&order=desc&page=\(page)&per_page=\(pageSize)"
        
        guard let scapedQueryString = queryString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: baseUrlString + scapedQueryString) else {
            fatalError("invalid url")
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = session.dataTask(
            with: request,
            completionHandler: { [weak self] (data, response, error) -> Void in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    
                    guard let data = data else {
                        return onComplete(RemoteResult<Page<Repository>>.error(error!))
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let repo = try decoder.decode(Page<Repository>.self,
                                                      from: data)
                        return onComplete(RemoteResult.succeeded(result: repo))
                        
                    } catch let error {
                        
                        return onComplete(RemoteResult<Page<Repository>>.error(error))
                    }
                }
        })
        
        dataTask.resume()
    }
    
}
