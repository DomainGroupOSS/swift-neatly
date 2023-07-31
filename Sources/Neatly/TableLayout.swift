//
//  TableLayout.swift
//  Domain
//
//  Created by Sam.Warner on 28/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

struct TableLayout {

    typealias Spacing = (horizontal: CGFloat, vertical: CGFloat)

    let columns: Int
    let spacing: Spacing
    let insets: UIEdgeInsets
}

extension TableLayout: LayoutFormatDescribing {

    public func prepare(sizedViews: [SizedView], in superview: UIView) -> [NSLayoutConstraint] {
        return TableLayout.prepare(for: sizedViews, in: superview, columns: self.columns, spacing: self.spacing, insets: self.insets)
    }

    static func prepare(for sizedViews: [SizedView], in superview: UIView, columns: Int, spacing: Spacing, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        let slices = sizedViews.split(chunkSize: columns)

        guard let firstSlice = slices.first, let lastSlice = slices.last else {
            return []
        }

        let topEdgeConstraints = firstSlice.map { view in
            view.view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
        }

        let sliceConstraints = slices.sliding().flatMap { slice, nextSlice -> [NSLayoutConstraint] in
            let sliceConstraints = self.prepare(forSlice: slice, in: superview, spacing: spacing, insets: insets)

            let verticalSpacingConstraints = nextSlice.flatMap { lowerView in
                slice.flatMap { view in
                    [
                        lowerView.view.topAnchor.constraint(equalTo: view.view.bottomAnchor, constant: spacing.vertical).with(priority: .for(.tableMinimalRowSpacing)),
                        lowerView.view.topAnchor.constraint(greaterThanOrEqualTo: view.view.bottomAnchor, constant: spacing.vertical)
                    ]
                }
            }

            return sliceConstraints + verticalSpacingConstraints
        }

        let lastSliceConstraints = self.prepare(forSlice: lastSlice, in: superview, spacing: spacing, insets: insets)

        return topEdgeConstraints + sliceConstraints + lastSliceConstraints
    }

    private static func prepare(forSlice slice: [SizedView], in superview: UIView, spacing: Spacing, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        guard let firstView = slice.first, let lastView = slice.last else {
            return []
        }

        let variableWidthViews = slice.filter { $0.width == nil }

        let horizontalEdgeConstraints = [
            firstView.view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left),
            lastView.view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right)
        ]

        let viewConstraints = slice.sliding().flatMap { view, nextView -> [NSLayoutConstraint] in
            let viewConstraints = self.prepare(forView: view, withEqualWidthTo: variableWidthViews, in: superview, spacing: spacing, insets: insets)

            let horizontalSpacing = nextView.view.leftAnchor.constraint(equalTo: view.view.rightAnchor, constant: spacing.horizontal)
            let verticalAlignment = nextView.view.topAnchor.constraint(equalTo: firstView.view.topAnchor)

            return viewConstraints + [horizontalSpacing, verticalAlignment].compactMap { $0 }
        }

        let lastViewConstraints = self.prepare(forView: lastView, withEqualWidthTo: variableWidthViews, in: superview, spacing: spacing, insets: insets)

        return horizontalEdgeConstraints + viewConstraints + lastViewConstraints
    }

    private static func prepare(forView view: SizedView, withEqualWidthTo otherViews: [SizedView], in superview: UIView, spacing: Spacing, insets: UIEdgeInsets) -> [NSLayoutConstraint] {
        let bottomEdgeConstraint = view.view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor, constant: -insets.bottom).with(priority: .for(.tableNoVerticalOverflow))

        let fixedHeightConstraint = view.height.map { height in
            view.view.heightAnchor.constraint(equalToConstant: height)
        }

        let fixedWidthConstraint = view.width.map { width in
            view.view.widthAnchor.constraint(equalToConstant: width)
        }

        let variableWidthConstraints = otherViews.compactMap { otherView in
            view.view.widthAnchor.constraint(equalTo: otherView.view.widthAnchor).with(priority: .for(.tableCellEqualWidth))
        }

        return [bottomEdgeConstraint] + [fixedHeightConstraint, fixedWidthConstraint].compactMap { $0 } + variableWidthConstraints
    }
}
