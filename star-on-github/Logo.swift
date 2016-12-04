//
//  Logo.swift
//  star-on-github
//
//  Created by Cale Newman on 11/7/16.
//  Copyright © 2016 newman.cale. All rights reserved.
//

import UIKit

class Logo: UIView {
    override func draw(_ rect: CGRect) {
        let strokeColor = UIColor(red: 0.071, green: 0.200, blue: 0.289, alpha: 1.000)
        let fillColor = UIColor(red: 0.071, green: 0.200, blue: 0.289, alpha: 1.000)

        //// Star Drawing
        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 115, y: 45))
        starPath.addLine(to: CGPoint(x: 137.05, y: 89.66))
        starPath.addLine(to: CGPoint(x: 186.33, y: 96.82))
        starPath.addLine(to: CGPoint(x: 150.67, y: 131.59))
        starPath.addLine(to: CGPoint(x: 159.08, y: 180.68))
        starPath.addLine(to: CGPoint(x: 115, y: 157.51))
        starPath.addLine(to: CGPoint(x: 70.92, y: 180.68))
        starPath.addLine(to: CGPoint(x: 79.33, y: 131.59))
        starPath.addLine(to: CGPoint(x: 43.67, y: 96.82))
        starPath.addLine(to: CGPoint(x: 92.95, y: 89.66))
        starPath.close()
        fillColor.setFill()
        starPath.fill()
        strokeColor.setStroke()
        starPath.lineWidth = 37.62
        starPath.stroke()
    }
}
