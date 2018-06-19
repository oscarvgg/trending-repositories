//
//  SearchDelegate.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 19/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import Foundation
import UIKit

class SearchDelegate: NSObject, UISearchBarDelegate {
    
    var blockOperation: BlockOperation?
    var coordinator: RepositoriesListCoordinator
    
    init(coordinator: RepositoriesListCoordinator) {
        self.coordinator = coordinator
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performActionAfter(milliseconds: 700,
                           dependencies: [
                            "searchTerm": searchBar.text ?? ""
            ])
    }
    
}

extension SearchDelegate: Delayable {
    
    func performDeleyedAction(dependencies: [String : Any]) {
        guard let searchTerm = dependencies["searchTerm"] as? String else {
            fatalError()
        }
        
        coordinator.currentTerm = searchTerm
    }
    
    
}
