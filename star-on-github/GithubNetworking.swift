//
//  GithubNetworking.swift
//  star-on-github
//
//  Created by Cale Newman on 11/4/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import Foundation

class GithubNetworking {
    static func authenticateWithGitHub(
        username: String,
        password: String,
        fingerprint: String,
        completion: @escaping (String?, Int?) -> Void
    ) {
        let (clientId, clientSecret) = getClientIdAndSecret()
        let githubUrl = URL(string: "https://api.github.com/authorizations/clients/\(clientId)/\(fingerprint)")
        let encodedCredentials = base64EncodeCredentials(username: username, password: password)
        
        let request = NSMutableURLRequest(url: githubUrl!)
        request.httpMethod = "PUT"
        let jsonData = authJsonData(clientSecret: clientSecret)
        let jsonString = try? JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
        request.httpBody = jsonString!
        request.setValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, err) in
            guard let data = data,
                let rawJson = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = rawJson as? [String: Any],
                let accessToken = json["token"] as? String,
                let authId = json["id"] as? Int
            else {
                return completion(nil, nil)
            }
            if accessToken.characters.count > 0 {
                UserDefaults.standard.setValue(accessToken, forKey: ACCESS_TOKEN_KEY)
                UserDefaults.standard.setValue(authId, forKey: AUTHORIZATION_ID_KEY)
                UserDefaults.standard.setValue(fingerprint, forKey: AUTHORIZATION_ID_KEY)
                
                if let sharedDefaults = UserDefaults.init(suiteName: APP_GROUP_NAME) {
                    sharedDefaults.set(accessToken, forKey: ACCESS_TOKEN_KEY)
                }
                
                return completion(accessToken, authId)
            }
            if let oldToken = UserDefaults.standard.string(forKey: ACCESS_TOKEN_KEY) {
                return completion(oldToken, authId)
            } else {
                return completion(nil, nil)
            }
        }
        
        task.resume()
    }
    
    static func checkAuthentication(token: String, completion: @escaping (Bool) -> Void) {
        let (clientId, clientSecret) = getClientIdAndSecret()
        let githubUrl = URL(
            string: "https://api.github.com/applications/\(clientId)/tokens/\(token)"
        )
        let encodedCredentials = base64EncodeCredentials(username: clientId, password: clientSecret)
        
        let request = NSMutableURLRequest(url: githubUrl!)
        request.httpMethod = "GET"
        request.setValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, err) in
            guard let resp = resp as? HTTPURLResponse
            else {
                return completion(false)
            }            
            return completion(resp.statusCode == 200)
        }
        
        task.resume()
    }
    
    static func fetchStarredRepositories(token: String, completion: @escaping ([Repository]) -> Void) {
        let githubUrl = URL(string: "https://api.github.com/user/starred?access_token=\(token)")
        let request = NSMutableURLRequest(url: githubUrl!)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, err) in
            guard let data = data,
                let rawJson = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = rawJson as? [[String: Any]]
            else {
                return completion([])
            }
            let repositories = json.flatMap({
                (repositoryJson: [String: Any]) -> Repository? in
                if let repository = Repository(json: repositoryJson) {
                    return repository
                } else {
                    return nil
                }
            })
            return completion(repositories)
        }
        
        task.resume()
    }
    
    static func logout(token: String, completion: @escaping (Bool) -> Void) {
        let (clientId, clientSecret) = getClientIdAndSecret()
        let githubUrl = URL(
            string: "https://api.github.com/applications/\(clientId)/tokens/\(token)"
        )
        let encodedCredentials = base64EncodeCredentials(username: clientId, password: clientSecret)
        
        let request = NSMutableURLRequest(url: githubUrl!)
        request.httpMethod = "DELETE"
        request.setValue("Basic \(encodedCredentials)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, resp, err) in
            guard let resp = resp as? HTTPURLResponse
            else {
                return completion(false)
            }
            if resp.statusCode != 204 {
                print("Bad response on logout: \(resp)")
            }
            UserDefaults.standard.removeObject(forKey: AUTHORIZATION_ID_KEY)
            UserDefaults.standard.removeObject(forKey: ACCESS_TOKEN_KEY)
            UserDefaults.standard.removeObject(forKey: FINGERPRINT_KEY)
            return completion(resp.statusCode == 204)
        }
        
        task.resume()
    }
    
    static func authJsonData(clientSecret: String) -> [String: Any] {
        return [
            "client_secret": clientSecret,
            "scopes": [
                "public_repo"
            ],
            "note": "star a repository"
        ]
    }
    
    static func base64EncodeCredentials(username: String, password: String) -> String {
        return Data("\(username):\(password)".utf8).base64EncodedString()
    }
    
    static func getClientIdAndSecret() -> (String, String) {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
            let secrets = NSDictionary(contentsOfFile: path),
            let clientId = secrets.object(forKey: "CLIENT_ID") as? String,
            let clientSecret = secrets.object(forKey: "CLIENT_SECRET") as? String
        else {
            return ("", "")
        }
        return (clientId, clientSecret)
    }
}
