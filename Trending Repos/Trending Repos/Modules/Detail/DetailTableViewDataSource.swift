//
//  RepositoryTableViewDataSource.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import UIKit
import TrendingReposData

class DetailTableViewDataSource: NSObject, UITableViewDataSource {
    
    var repository: Repository?
    
    enum Rows: Int {
        case language
        case numberOfForks
        case numberOfStars
        case creationDate
        
        static let count: Int = {
            var max = 0
            
            while let _ = Rows(rawValue: max) {
                max += 1
            }
            
            return max
        }()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (repository != nil ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Rows.count - (repository?.language != nil ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realRowIndex = indexPath.row + (repository?.language != nil ? 0 : 1)
        
        guard let rowType = Rows(rawValue: realRowIndex), let repository = repository else {
            fatalError("Invalid row")
        }
        
        switch rowType {
        case .language:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController
                .ReuseIdentifier
                .languageCell
                .rawValue) else {
                fatalError("Invalid cell")
            }
            cell.textLabel?.text = repository.language
            
            return cell
        case .numberOfForks:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController
                .ReuseIdentifier
                .forksCell
                .rawValue) else {
                    fatalError("Invalid cell")
            }
            cell.textLabel?.text = "\(repository.forkCount) forks"
            
            return cell
            
        case .numberOfStars:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController
                .ReuseIdentifier
                .starsCell
                .rawValue) else {
                    fatalError("Invalid cell")
            }
            cell.textLabel?.text = "\(repository.starCount) stars"
            
            return cell
        case .creationDate:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DetailViewController
                .ReuseIdentifier
                .createdOnCell
                .rawValue) else {
                    fatalError("Invalid cell")
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            let formatedDate = dateFormatter.string(from: repository.createdAt)
            cell.textLabel?.text = "Created on \(formatedDate)"
            
            return cell
        }
    }
    
}
