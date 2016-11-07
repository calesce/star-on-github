//
//  Language.swift
//  star-on-github
//
//  Created by Cale Newman on 11/1/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import Foundation
import UIKit

enum Language: String {
    case JavaScript = "JavaScript"
    case Swift = "Swift"
    case Ruby = "Ruby"
    case Python = "Python"
    case Java = "Java"
    case CSS = "CSS"
    case Rust = "Rust"
    case Elixir = "Elixir"
    case C = "C"
    case PHP = "PHP"
    case CPP = "C++"
    case Shell = "Shell"
    case CSharp = "C#"
    case Go = "Go"
    case EmacsLisp = "Emacs Lisp"
    case ObjectiveC = "Objective-C"
    case None
    
    // https://github.com/ozh/github-colors/blob/master/colors.json
    var hexCode: String {
        switch self{
        case .JavaScript:
            return "#f1e05a"
        case .Swift:
            return "#ffac45"
        case .Ruby:
            return "#701516"
        case .Python:
            return "#3572A5"
        case .Java:
            return "#b07219"
        case .CSS:
            return "#563d7c"
        case .Rust:
            return "#dea584"
        case .Elixir:
            return "#6e4a7e"
        case .C:
            return "#555555"
        case .PHP:
            return "#4F5D95"
        case .CPP:
            return "#f34b7d"
        case .Shell:
            return "#89e051"
        case .CSharp:
            return "#178600"
        case .Go:
            return "#375eab"
        case .EmacsLisp:
            return "#c065db"
        case .ObjectiveC:
            return "#438eff"
        case .None:
            return "#d3d3d3"
        }
    }
}
