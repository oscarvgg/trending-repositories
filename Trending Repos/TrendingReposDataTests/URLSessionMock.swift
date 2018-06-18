//
//  RemoteDataStoreFake.swift
//  TrendingReposDataTests
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation


class URLSessionMock: URLSession {
    
    var data: Data?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        completionHandler(data, nil, nil)
        return DataTaskMock()
    }
}


class DataTaskMock: URLSessionDataTask {
    
    override func resume() {
        return
    }
}
