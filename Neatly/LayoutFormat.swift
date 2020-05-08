//
//  UIViewLayoutExtensions.swift
//  Domain
//
//  Created by Sam.Warner on 5/07/2016.
//  Copyright © 2016 Fairfax Digital. All rights reserved.
//

import UIKit

public protocol LayoutFormatDescribing {

    /**
     Prepare but do not install contraints representing the given `layout` of `views` in `superview`.

     Where `width`s or `height`s are provided, fix view sizes. Fit remaining `views` to the available space, respecting their `instrinsicContentSize`.
     */
    func prepare(sizedViews: [SizedView], in superview: UIView) -> [NSLayoutConstraint]
}

public extension Layout {

    enum Format {

        case stack(axis: NSLayoutConstraint.Axis, spacing: CGFloat, insets: UIEdgeInsets, lowPriorityPadding: Bool)
        case fill(axis: NSLayoutConstraint.Axis, spacing: CGFloat, insets: UIEdgeInsets, lowPriorityPadding: Bool)
        case table(columns: Int, horizontalSpacing: CGFloat, verticalSpacing: CGFloat, insets: UIEdgeInsets)

        var formatDescribing: LayoutFormatDescribing {
            switch self {
            case let .stack(axis, spacing, insets, lowPriorityPadding):
                return StackLayout(axis: axis, lowPrioritySpacing: false, spacing: spacing, lowPriorityPadding: lowPriorityPadding, insets: insets, fill: false)
            case let .fill(axis, spacing, insets, lowPriorityPadding):
                return StackLayout(axis: axis, lowPrioritySpacing: false, spacing: spacing, lowPriorityPadding: lowPriorityPadding, insets: insets, fill: true)
            case let .table(columns, horizontalSpacing, verticalSpacing, insets):
                return TableLayout(columns: columns, spacing: (horizontalSpacing, verticalSpacing), insets: insets)
            }
        }
    }
}
