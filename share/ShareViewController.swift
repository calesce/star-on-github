//
//  ShareViewController.swift
//  share
//
//  Created by Cale Newman on 11/8/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

let ACCESS_TOKEN_KEY = "accessToken"
let APP_GROUP_NAME = "group.com.newman.cale.star"

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = self.extensionContext!

        for item in context.inputItems {
            guard let item = item as? NSExtensionItem,
                let attachments = item.attachments
            else {
                return self.closeExtension()
            }
            for itemProvider in attachments {
                guard let itemProvider = itemProvider as? NSItemProvider
                else {
                    return self.closeExtension()
                }
                itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) {
                    result, error in
                    if let url = result as? URL {
                        self.attemptToStarWithUrl(url: url)
                    } else {
                        print("\(error)")
                        self.closeExtension()
                    }
                }
            }
        }
    }

    func attemptToStarWithUrl(url: URL) {
        self.getExpandedUrl(url: url) {
            fullUrl in
            if let fullUrl = fullUrl,
                let pathComponents = self.parseGitHubUrl(url: fullUrl) {
                self.starARepository(owner: pathComponents[0], repo: pathComponents[1]) {
                    success in
                    if success {
                        print("starred \(pathComponents[1])")
                    } else {
                        print("unable to star \(pathComponents[1])")
                    }
                    self.closeExtension()
                }
                return
            }
            self.closeExtension()
        }
    }

    func getExpandedUrl(url: URL, completion: @escaping (URL?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            if let resp = response as? HTTPURLResponse {
                return completion(resp.url)
            }
            return completion(nil)
        }
        task.resume()
    }

    func parseGitHubUrl(url: URL) -> [String]? {
        if let host = url.host {
            let pathComponents = url.path.characters.split { $0 == "/" }.map(String.init)
            return (host == "github.com" && pathComponents.count > 1) ? pathComponents : nil
        }
        return nil
    }

    func starARepository(owner: String, repo: String, completion: @escaping (Bool) -> Void) {
        guard let sharedDefaults = UserDefaults.init(suiteName: APP_GROUP_NAME),
            let token = sharedDefaults.string(forKey: ACCESS_TOKEN_KEY)
        else {
            return completion(false)
        }
        let githubUrl = URL(string: "https://api.github.com/user/starred/\(owner)/\(repo)?access_token=\(token)")
        let request = NSMutableURLRequest(url: githubUrl!)
        request.httpMethod = "PUT"

        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, resp, err in
            guard let response = resp as? HTTPURLResponse
            else {
                return completion(false)
            }
            return completion(response.statusCode == 204)
        }

        task.resume()
    }

    func closeExtension() {
        DispatchQueue.main.async {
            self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
}
