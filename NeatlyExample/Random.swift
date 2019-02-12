//
//  RandomNumbers.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

extension CGFloat {

    static func random(in range: ClosedRange<CGFloat>) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(range.upperBound) - UInt32(range.lowerBound)) + UInt32(range.lowerBound))
    }
}

extension UIColor {

    static func random() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0,
                       green: CGFloat(arc4random_uniform(255)) / 255.0,
                       blue: CGFloat(arc4random_uniform(255)) / 255.0,
                       alpha: 1.0)
    }
}
