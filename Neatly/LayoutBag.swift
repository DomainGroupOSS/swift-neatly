//
//  LayoutBag.swift
//  Domain
//
//  Created by Sam.Warner on 28/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import Foundation

public extension Layout {

    /**
     Describes the layout of views when `prepared` or `arranged` with the given `Format`.

     - parameter stack: arranges views in a vertical or horizontal stack, with the given spacing.
     - parameter flow: arranges views in rows with the given number of columns, with the given horizontal and vertical spacing.
     */

    public struct Bag<Constraint: ConstraintDescribing>: ConstraintContaining {

        public let constraints: [Constraint]

        public init(constraints: [Constraint]) {
            self.constraints = constraints
        }
    }

    public struct SizeBag<Constraint: ConstraintDescribing>: ConstraintContaining {

        private let width: Constraint
        private let height: Constraint

        public var constraints: [Constraint] { return [width, height] }

        public init(width: Constraint, height: Constraint) {
            self.width = width
            self.height = height
        }

        public func setFixed(width: CGFloat?, height: CGFloat?) {
            if let width = width {
                self.width.update(constant: width)
                self.width.activate()
            }

            if let height = height {
                self.height.update(constant: height)
                self.height.activate()
            }
        }
    }

    public class MutableBag<Constraint: ConstraintDescribing>: ConstraintContaining {

        public var constraints: [Constraint] = []

        public init() {}

        public func add(constraint: Constraint) {
            self.constraints.append(constraint)
        }
    }
}
