//
//  TrendingReposDataTests.swift
//  TrendingReposDataTests
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import XCTest
@testable import TrendingReposData

class RemoteDataStoreTests: XCTestCase {
    
    func testGetRepositories() {
        
        struct DateFilter: DateFilterable {
            var date: Date { return Date() }
        }
        
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "testData.json", withExtension: nil) else {
            fatalError()
        }
        let data = try! Data(contentsOf: url)
        
        let fakeSession = URLSessionMock()
        fakeSession.data = data
        let store = RemoteDataStore()
        store.session = fakeSession
        
        store.getRepositories(
            withQuery: "test",
            dateFilter: DateFilter()) { (result) in
                switch result {
                case .succeeded(let result):
                    let repo = result.items[0]
                    XCTAssertEqual(repo.identifier, 3081286)
                    XCTAssertEqual(repo.name, "Tetris")
                    XCTAssertEqual(repo.description, "A C implementation of Tetris using Pennsim through LC4")
                    XCTAssertEqual(repo.starCount, 1)
                    XCTAssertEqual(repo.language, "Assembly")
                    XCTAssertEqual(repo.forkCount, 0)
                    XCTAssertEqual(repo.createdAt,
                                   Formatter.iso8601.date(from: "2012-01-01T00:31:50Z"))
                    
                    let user = repo.owner
                    XCTAssertEqual(user.identifier, 872147)
                    XCTAssertEqual(user.username, "dtrupenn")
                    XCTAssertEqual(user.avatarUrl, "https://secure.gravatar.com/avatar/e7956084e75f239de85d3a31bc172ace?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png")
                    
                default:
                    break
                }
        }
    }
    
}
