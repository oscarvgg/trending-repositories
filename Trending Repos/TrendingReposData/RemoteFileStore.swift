//
//  RemoteFileStore.swift
//  TrendingReposData
//
//  Created by Oscar Gonzalez on 19/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

final public class RemoteFileStore {
    
    var session = URLSession.shared
    var cache = NSCache<AnyObject, AnyObject>()
    
    public init() {}
    
    public func get(url: URL, onComplete: @escaping (RemoteResult<Data>) -> ()) {
        // data is already available
        if let cachedData = cache.object(forKey: url as AnyObject) as? Data {
            return onComplete(.succeeded(result: cachedData))
        }
        let request = URLRequest(url: url)
        // data wasn't in cache. Get it from server
        session.dataTask(
            with: request,
            completionHandler: { [weak self] (data, response, error) in
                
                DispatchQueue.main.async {
                    
                    guard let data = data else {
                        return onComplete(.error(error!))
                    }
                    self?.cache.setObject(data as AnyObject,
                                          forKey: url as AnyObject)
                    onComplete(.succeeded(result: data))
                }
                
        }).resume()
    }
}
