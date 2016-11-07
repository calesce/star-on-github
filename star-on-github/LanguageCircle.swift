//
//  LanguageCircle.swift
//  star-on-github
//
//  Created by Cale Newman on 11/7/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import UIKit

class LanguageCircle: UIView {
    var fillColor: UIColor = UIColor.green

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
    }
}
