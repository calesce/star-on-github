//
//  Keychain.swift
//  star-on-github
//
//  Created by Cale Newman on 11/4/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import Foundation
import Security

class Keychain {
    static let KeychainAccount = "last user"
    static let KeychainErrorDomain = Bundle.main.bundleIdentifier ?? ""
    
    static func saveData(data: [String: NSCoding], userAccount: String) -> NSError? {
        return nil
    }
    
    static func loadData(userAccount: String) {
        
    }
    
    static func deleteData() {
        
    }
    
    private static func createAttributes(userAccount: String) -> NSMutableDictionary {
        let attributes = NSMutableDictionary()
        
        attributes.setObject(userAccount, forKey: kSecAttrAccount as NSString)
        attributes.setObject(userAccount, forKey: kSecAttrAccessGroup as NSString)
        attributes.setObject(userAccount, forKey: kSecAttrService as NSString)
        attributes.setObject(userAccount, forKey: kSecClass as NSString)
        
        return attributes
    }
}
