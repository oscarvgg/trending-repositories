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
    @IBOutlet weak var openUrlButton: UIButton!
    let emptyViewLabel: UILabel = UILabel()
    
    weak var coordinator: DetailCoordinator? {
        didSet {
            coordinator?.delegate = self
            tableViewDataSource.repository = coordinator?.repository
            coordinator?.start()
            title = coordinator?.repository?.name
        }
    }
    
    var tableViewDataSource = DetailTableViewDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = tableViewDataSource
        openUrlButton.clipsToBounds = true
        openUrlButton.layer.cornerRadius = 4
    }
    
    @IBAction func openOnGithub(_ sender: UIButton) {
        guard let urlString = coordinator?.repository?.url,
            let url = URL(string: urlString) else {
            return
        }
        UIApplication.shared.open(
            url,
            options: [:]) { (suceeded) in
                
        }
    }
    
}

extension DetailViewController: CoordinatorDelegate {
    
    func update() {
        if coordinator?.repository == nil {
            tableView.backgroundView = emptyViewLabel
            openUrlButton.alpha = 0
            descriptionLabel?.text = nil
            emptyViewLabel.text = DetailViewController.noSelectionText
            emptyViewLabel.textAlignment = .center
            emptyViewLabel.textColor = .black
            
        } else {
            tableView.backgroundView = nil
            openUrlButton.alpha = 1
            descriptionLabel?.text = coordinator?.repository?.description ?? "No description"
            tableViewDataSource.repository = coordinator?.repository
        }
        tableView.reloadData()
    }
}

