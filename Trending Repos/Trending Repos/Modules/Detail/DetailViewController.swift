//
//  DetailViewController.swift
//  Trending Repos
//
//  Created by Oscar Gonzalez on 18/06/2018.
//  Copyright © 2018 Oscar Gonzalez. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    let emptyViewLabel: UILabel = UILabel()
    
    weak var coordinator: DetailCoordinator? {
        didSet {
            coordinator?.delegate = self
            tableViewDataSource.repository = coordinator?.repository
            coordinator?.start()
        }
    }
    
    var tableViewDataSource = DetailTableViewDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableViewDataSource
    }
}

extension DetailViewController: CoordinatorDelegate {
    
    func update() {
        if coordinator?.repository == nil {
            tableView.backgroundView = emptyViewLabel
            descriptionLabel?.text = nil
            emptyViewLabel.text = DetailViewController.noSelectionText
            emptyViewLabel.textAlignment = .center
            emptyViewLabel.textColor = .black
            
        } else {
            tableView.backgroundView = nil
            descriptionLabel?.text = coordinator?.repository?.description ?? "No description"
            tableViewDataSource.repository = coordinator?.repository
        }
        tableView.reloadData()
    }
}

