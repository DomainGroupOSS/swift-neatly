//
//  LayoutAnchorer.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

public extension Layout {

    public struct Anchorer {

        private let edges: Layout.Edges
        private let sizedSubview: SizedView

        init(edges: Layout.Edges, sizedSubview: SizedView) {
            self.edges = edges
            self.sizedSubview = sizedSubview
        }

        /**
         Prepare and install contraints representing the given `layout` of `views` in `superview`.

         Fit `views` to the `available` space, respecting their `instrinsicContentSize`.
         */
        @discardableResult
        public func anchored(to edges: UIRectEdge, insets: UIEdgeInsets = .zero) -> Layout.Bag<NSLayoutConstraint> {
            let layout = AnchoredLayout(edges: edges, to: self.edges, insets: insets)
            return Anchorer.layout(sizedSubview: self.sizedSubview, with: layout)
        }

        /**
         Prepare and install contraints representing the given `layout` of `views` in `superview`.

         Fit `views` to the `available` space, respecting their `instrinsicContentSize`.
         */
        @discardableResult
        public func anchored(
            top: NSLayoutYAxisAnchor?,
            left: NSLayoutXAxisAnchor?,
            bottom: NSLayoutYAxisAnchor?,
            right: NSLayoutXAxisAnchor?,
            insets: UIEdgeInsets = .zero) -> Layout.Bag<NSLayoutConstraint>
        {
            let layout = AnchoredLayout(
                topAnchor: top,
                leftAnchor: left,
                bottomAnchor: bottom,
                rightAnchor: right,
                insets: insets
            )
            return Anchorer.layout(sizedSubview: self.sizedSubview, with: layout)
        }

        /**
         Prepare and install contraints representing the given `layout` of `views` in `superview`.

         Fit `views` to the `available` space, respecting their `instrinsicContentSize`.
         */
        @discardableResult
        public func anchored(
            layoutGuide: UILayoutGuide,
            insets: UIEdgeInsets = .zero) -> Layout.Bag<NSLayoutConstraint>
        {
            let layout = AnchoredLayout(
                topAnchor: layoutGuide.topAnchor,
                leftAnchor: layoutGuide.leftAnchor,
                bottomAnchor: layoutGuide.bottomAnchor,
                rightAnchor: layoutGuide.rightAnchor,
                insets: insets
            )
            return Anchorer.layout(sizedSubview: self.sizedSubview, with: layout)
        }

        static func layout(sizedSubview: SizedView, with layout: AnchoredLayout) -> Layout.Bag<NSLayoutConstraint> {
            let bag = self.prepare(layout: layout, of: sizedSubview)
            bag.activate()
            return bag
        }

        static func prepare(layout: AnchoredLayout, of sizedSubview: SizedView) -> Layout.Bag<NSLayoutConstraint> {
            sizedSubview.view.translatesAutoresizingMaskIntoConstraints = false
            return Bag(constraints: layout.prepare(sizedView: sizedSubview))
        }
    }
}
