//
//  ViewController.swift
//  star-on-github
//
//  Created by Cale Newman on 10/31/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import UIKit

let ACCESS_TOKEN_KEY = "accessToken"
let AUTHORIZATION_ID_KEY = "authorizationId"
let FINGERPRINT_KEY = "fingerprint"
let APP_GROUP_NAME = "group.com.newman.cale.star"

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var authorizationId: Int?
    var token: String?

    override func viewDidLoad() {
        guard let token = UserDefaults.standard.string(forKey: ACCESS_TOKEN_KEY)
        else {
            return
        }
        
        self.token = token
        self.authorizationId = UserDefaults.standard.integer(forKey: AUTHORIZATION_ID_KEY)
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.usernameField.text = ""
        self.passwordField.text = ""
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""

        if username.isEmpty {
            showAlert(title: "Username required")
            return
        } else if password.isEmpty {
            showAlert(title: "Password required")
            return
        }
        
        GithubNetworking.authenticateWithGitHub(
            username: username,
            password: password,
            fingerprint: getExistingFingerprintOrRandom()
        ) {
            (token, authId) in
            self.token = token
            self.authorizationId = authId
            
            DispatchQueue.main.async {
                if token != nil {
                    self.performSegue(withIdentifier: "loginSegue", sender: sender)
                } else {
                    self.showAlert(title: "Bad credentials")
                    self.passwordField.text = ""
                }
            }
        }
    }
    
    func randomFingerprint() -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< 16 {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func getExistingFingerprintOrRandom() -> String {
        if let fingerprint = UserDefaults.standard.string(forKey: FINGERPRINT_KEY) {
            return fingerprint
        }
        return randomFingerprint()
    }
    
    func showAlert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController, 
            let starredRepositoriesVc = navigationController.viewControllers.first as? StarredRepositoriesViewController {
            starredRepositoriesVc.token = self.token
            starredRepositoriesVc.authorizationId = self.authorizationId
        }
    }
}
