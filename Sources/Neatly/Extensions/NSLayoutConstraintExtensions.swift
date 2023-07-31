//
//  NSLayoutConstraintExtensions.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import Foundation
import UIKit

extension NSLayoutConstraint: ConstraintDescribing {

    public func activate() {
        self.isActive = true
    }

    public func deactivate() {
        self.isActive = false
    }

    public func update(constant: CGFloat) {
        self.constant = constant
    }
}

public extension NSLayoutConstraint {

    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
