//
//  Repository.swift
//  star-on-github
//
//  Created by Cale Newman on 11/1/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import Foundation

struct Repository {
    var owner: String
    var name: String
    var language: Language
    var stargazers: Int
}

extension Repository {
    init?(json: [String: Any]) {
        guard let ownerDict = json["owner"] as? [String: Any],
            let ownerName = ownerDict["login"] as? String,
            let name = json["name"] as? String,
            let stargazers = json["stargazers_count"] as? Int
        else {
            return nil
        }
        
        if let languageString = json["language"] as? String,
            let language = Language(rawValue: languageString) {
            self.language = language
        } else {
            self.language = Language.None
        }
         
        self.owner = ownerName
        self.name = name
        self.stargazers = stargazers
    }
}
