//
//  StarredRepositoriesViewController.swift
//  star-on-github
//
//  Created by Cale Newman on 11/1/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import UIKit

let reuseIdentifier = "repositoryView"

class StarredRepositoriesViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var repositoriesCollectionView: UICollectionView!
    var token: String?
    var authorizationId: Int?
    var repositories: [Repository] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.repositoriesCollectionView.dataSource = self
        self.navigationItem.title = "Starred Repositories"

        if let token = self.token {
            GithubNetworking.fetchStarredRepositories(token: token) {
                repositories in
                self.repositories = repositories
                
                DispatchQueue.main.async {
                    self.repositoriesCollectionView.reloadData()
                }
            }
        }
        
        let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    func logout() {
        GithubNetworking.logout(token: self.token ?? "") {
            success in
            DispatchQueue.main.async {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension StarredRepositoriesViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.repositories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, 
                                                      for: indexPath) as! GithubRepositoryCell
        
        let repository = self.repositories[indexPath.row]
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = UIColor.darkGray.cgColor
        
        cell.nameLabel.text = repository.name
        cell.ownerLabel.text = "by \(repository.owner)"
        cell.starCountLabel.text = "\(repository.stargazers) stars"
        
        return cell
    }
}
