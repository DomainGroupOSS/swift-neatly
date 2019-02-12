//
//  LayoutPriorities.swift
//  Domain
//
//  Created by Sam.Warner on 30/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

extension Layout {

    enum Priority: UILayoutPriority {
        case tableMinimalRowSpacing = 750
        case tableNoVerticalOverflow
        case tableCellEqualWidth
        case stackItemMinorEdgeAnchors
    }
}

extension UILayoutPriority {

    static func `for`(_ priority: Layout.Priority) -> UILayoutPriority {
        return priority.rawValue
    }
}

extension UILayoutPriority: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        self.init(rawValue: Float(value))
    }

    public static func + (lhs: UILayoutPriority, rhs: UILayoutPriority) -> UILayoutPriority {
        return UILayoutPriority(rawValue: lhs.rawValue + rhs.rawValue)
    }

    public static func - (lhs: UILayoutPriority, rhs: UILayoutPriority) -> UILayoutPriority {
        return UILayoutPriority(rawValue: lhs.rawValue - rhs.rawValue)
    }
}
