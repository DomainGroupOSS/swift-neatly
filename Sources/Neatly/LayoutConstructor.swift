//
//  LayoutConstructor.swift
//  Domain
//
//  Created by Sam.Warner on 28/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

public extension Layout {

    struct Constructor {

        private let superview: UIView
        private let sizedSubviews: [SizedView]

        init(superview: UIView, sizedSubviews: [SizedView]) {
            self.superview = superview
            self.sizedSubviews = sizedSubviews
        }

        /**
         Prepare and install contraints representing the given `layout` of `views` in `superview`.

         Where `width`s or `height`s are provided, fix view sizes. Fit remaining `views` to the available space, respecting their `instrinsicContentSize`.
         */
        @discardableResult
        public func with(format: LayoutFormatDescribing) -> Layout.Bag<NSLayoutConstraint> {
            return Constructor.layout(sizedSubviews: self.sizedSubviews, in: self.superview, with: format)
        }

        /**
         Prepare and install contraints representing the given `layout` of `views` in `superview`.

         Fit `views` to the `available` space, respecting their `instrinsicContentSize`.
         */
        @discardableResult
        public func with(format: Layout.Format) -> Layout.Bag<NSLayoutConstraint> {
            return Constructor.layout(sizedSubviews: self.sizedSubviews, in: self.superview, with: format.formatDescribing)
        }

        static func layout(sizedSubviews sizedViews: [SizedView], in superview: UIView, with layout: LayoutFormatDescribing) -> Layout.Bag<NSLayoutConstraint> {
            let bag = prepare(layout: layout, of: sizedViews, in: superview)
            bag.activate()
            return bag
        }

        static func prepare(layout: LayoutFormatDescribing, of sizedViews: [SizedView], in superview: UIView) -> Layout.Bag<NSLayoutConstraint> {
            sizedViews.map { $0.view }.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
            return Bag(constraints: layout.prepare(sizedViews: sizedViews, in: superview))
        }
    }
}
