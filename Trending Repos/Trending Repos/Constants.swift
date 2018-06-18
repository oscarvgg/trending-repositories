//
//  Constants.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation

extension RepositoriesListViewController {
    
    enum ReuseIdentifier: String {
        case repositoryCell
    }
}

extension DetailViewController {
    
    enum ReuseIdentifier: String {
        case languageCell
        case forksCell
        case starsCell
        case createdOnCell
    }
    
    static let noSelectionText = "Please, select a repository"
}
