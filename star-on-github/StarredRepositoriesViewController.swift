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
    var isFirstViewController: Bool = false
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
        
        let coolColor = UIColor(red: 21.0 / 255, green: 67.0 / 255, blue: 92.0 / 255, alpha: 1)
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.barTintColor = coolColor
            navigationBar.isTranslucent = false
            navigationBar.barStyle = UIBarStyle.black
            navigationBar.tintColor = UIColor.white
        }
       
        
        let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logout))
        logoutButton.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = logoutButton
    }
    
    func logout() {
        GithubNetworking.logout(token: self.token ?? "") {
            success in
            DispatchQueue.main.async {
                if self.isFirstViewController {
                    self.isFirstViewController = false
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "login")
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = loginViewController
                } else {
                    self.navigationController?.dismiss(animated: true, completion: nil)
                }
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
