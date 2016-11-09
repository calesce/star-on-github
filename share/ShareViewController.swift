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

class ShareViewController: UIViewController, URLSessionTaskDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let context = self.extensionContext!
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
        
        for item in context.inputItems {
            if let item = item as? NSExtensionItem,
            let attachments = item.attachments {
                for itemProvider in attachments {
                    if let itemProvider = itemProvider as? NSItemProvider {
                        itemProvider.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil) {
                            (result, error) in
                            
                            if let url = result as? URL {
                                let task = session.dataTask(with: url) {
                                    (data, response, error) in
                                    print("\(response?.url?.absoluteString)")
                                    DispatchQueue.main.async {
                                        self.extensionContext!.completeRequest(returningItems: nil, completionHandler: nil)
                                    }
                                }
                                task.resume()
                            } else {
                                print("\(error)")
                                context.completeRequest(returningItems: nil, completionHandler: nil)
                            }
                        } 
                    }
                }
            }
        }
    }
}
