//
//  StackLayout.swift
//  Domain
//
//  Created by Sam.Warner on 28/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

struct StackLayout {
    let axis: NSLayoutConstraint.Axis
    let spacing: CGFloat
    let insets: UIEdgeInsets
    let fill: Bool
}

extension StackLayout: LayoutFormatDescribing {

    public func prepare(sizedViews: [SizedView], in superview: UIView) -> [NSLayoutConstraint] {
        switch self.axis {
        case .vertical:
            return StackLayout.prepareVertical(for: sizedViews, in: superview, spacing: spacing, insets: insets, fill: fill)
        case .horizontal:
            return StackLayout.prepareHorizontal(for: sizedViews, in: superview, spacing: spacing, insets: insets, fill: fill)
        @unknown default:
            fatalError("unexpected axis: \(self.axis)")
        }
    }

    static func prepareVertical(for sizedViews: [SizedView], in superview: UIView, spacing: CGFloat, insets: UIEdgeInsets, fill: Bool) -> [NSLayoutConstraint] {
        return prepare(
            for: sizedViews,
            in: superview,
            spacing: spacing,
            fill: fill,
            minorPadding: (insets.left, insets.right),
            majorPadding: (insets.top, insets.bottom),
            minorEdgeMinimum: { $0.leftAnchor },
            minorEdgeMaximum: { $0.rightAnchor },
            majorEdgeMinimum: { $0.topAnchor },
            majorEdgeMaximum: { $0.bottomAnchor },
            majorDimension: { $0.heightAnchor },
            majorDimensionValue: { $0.height },
            minorDimension: { $0.widthAnchor },
            minorDimensionValue: { $0.width },
            minorCenter: { $0.centerXAnchor })
    }

    static func prepareHorizontal(for sizedViews: [SizedView], in superview: UIView, spacing: CGFloat, insets: UIEdgeInsets, fill: Bool) -> [NSLayoutConstraint] {
        return prepare(
            for: sizedViews,
            in: superview,
            spacing: spacing,
            fill: fill,
            minorPadding: (insets.top, insets.bottom),
            majorPadding: (insets.left, insets.right),
            minorEdgeMinimum: { $0.topAnchor },
            minorEdgeMaximum: { $0.bottomAnchor },
            majorEdgeMinimum: { $0.leftAnchor },
            majorEdgeMaximum: { $0.rightAnchor },
            majorDimension: { $0.widthAnchor },
            majorDimensionValue: { $0.width },
            minorDimension: { $0.heightAnchor },
            minorDimensionValue: { $0.height },
            minorCenter: { $0.centerYAnchor })
    }

    typealias AxisAnchorProducer<Axis: AnyObject> = (UIView) -> NSLayoutAnchor<Axis>
    typealias DimensionAnchorProducer = (UIView) -> NSLayoutDimension
    typealias ValueProducer = (SizedView) -> CGFloat?

    // swiftlint:disable function_parameter_count
    static func prepare<MajorAxis, MinorAxis>(
        for sizedViews: [SizedView],
        in superview: UIView,
        spacing: CGFloat,
        fill: Bool,
        minorPadding: (CGFloat, CGFloat),
        majorPadding: (CGFloat, CGFloat),
        minorEdgeMinimum: AxisAnchorProducer<MinorAxis>,
        minorEdgeMaximum: AxisAnchorProducer<MinorAxis>,
        majorEdgeMinimum: AxisAnchorProducer<MajorAxis>,
        majorEdgeMaximum: AxisAnchorProducer<MajorAxis>,
        majorDimension: DimensionAnchorProducer,
        majorDimensionValue: ValueProducer,
        minorDimension: DimensionAnchorProducer,
        minorDimensionValue: ValueProducer,
        minorCenter: AxisAnchorProducer<MinorAxis>) -> [NSLayoutConstraint]
    {
        guard let firstView = sizedViews.first, let lastView = sizedViews.last else {
            return []
        }

        let minEdge = majorEdgeMinimum(firstView.view).constraint(equalTo: majorEdgeMinimum(superview), constant: majorPadding.0)

        let viewConstraints = sizedViews.sliding().flatMap { view, nextView -> [NSLayoutConstraint] in
            let majorConstraints = self.prepareMajor(forView: view, in: superview, majorPadding: majorPadding,
                                                     majorEdgeMinimum: majorEdgeMinimum, majorEdgeMaximum: majorEdgeMaximum,
                                                     majorDimension: majorDimension, majorDimensionValue: majorDimensionValue)

            let minorConstraints = self.prepareMinor(forView: view, in: superview, minorPadding: minorPadding,
                                                     minorEdgeMinimum: minorEdgeMinimum, minorEdgeMaximum: minorEdgeMaximum,
                                                     minorDimension: minorDimension, minorDimensionValue: minorDimensionValue,
                                                     minorCenter: minorCenter)

            let spacing = [majorEdgeMinimum(nextView.view).constraint(equalTo: majorEdgeMaximum(view.view), constant: spacing)]
            let width = fill ? [majorDimension(nextView.view).constraint(equalTo: majorDimension(view.view), multiplier: 1).with(priority: 500)] : []

            return majorConstraints + minorConstraints + spacing + width
        }

        let lastViewMajor = self.prepareMajor(
                forView: lastView, in: superview, majorPadding: majorPadding,
                majorEdgeMinimum: majorEdgeMinimum, majorEdgeMaximum: majorEdgeMaximum,
                majorDimension: majorDimension, majorDimensionValue: majorDimensionValue)

        let lastViewMinor = self.prepareMinor(
                forView: lastView, in: superview, minorPadding: minorPadding,
                minorEdgeMinimum: minorEdgeMinimum, minorEdgeMaximum: minorEdgeMaximum,
                minorDimension: minorDimension, minorDimensionValue: minorDimensionValue,
                minorCenter: minorCenter)

        let lastViewRight = fill ? [majorEdgeMaximum(lastView.view).constraint(equalTo: majorEdgeMaximum(superview), constant: -majorPadding.1)] : []

        let lastViewConstraints = lastViewMajor + lastViewMinor + lastViewRight

        return [minEdge] + viewConstraints + lastViewConstraints
    }

    private static func prepareMajor<MajorAxis>(
        forView sizedView: SizedView,
        in superview: UIView,
        majorPadding: (CGFloat, CGFloat),
        majorEdgeMinimum: AxisAnchorProducer<MajorAxis>,
        majorEdgeMaximum: AxisAnchorProducer<MajorAxis>,
        majorDimension: DimensionAnchorProducer,
        majorDimensionValue: ValueProducer) -> [NSLayoutConstraint]
    {
        let maxEdge = majorEdgeMaximum(sizedView.view).constraint(lessThanOrEqualTo: majorEdgeMaximum(superview), constant: -majorPadding.1)

        let majorDimensionConstraint = majorDimensionValue(sizedView).map { major in
            majorDimension(sizedView.view).constraint(equalToConstant: major)
        }

        return [maxEdge] + (majorDimensionConstraint.map { [$0] } ?? [])
    }

    private static func prepareMinor<MinorAxis>(
        forView sizedView: SizedView,
        in superview: UIView,
        minorPadding: (CGFloat, CGFloat),
        minorEdgeMinimum: AxisAnchorProducer<MinorAxis>,
        minorEdgeMaximum: AxisAnchorProducer<MinorAxis>,
        minorDimension: DimensionAnchorProducer,
        minorDimensionValue: ValueProducer,
        minorCenter: AxisAnchorProducer<MinorAxis>) -> [NSLayoutConstraint]
    {
        if let fixedMinorDimension = minorDimensionValue(sizedView) {
            return [
                minorEdgeMinimum(sizedView.view).constraint(greaterThanOrEqualTo: minorEdgeMinimum(superview), constant: minorPadding.0),
                minorEdgeMaximum(sizedView.view).constraint(lessThanOrEqualTo: minorEdgeMaximum(superview), constant: -minorPadding.1),
                minorDimension(sizedView.view).constraint(equalToConstant: fixedMinorDimension),
                minorCenter(sizedView.view).constraint(equalTo: minorCenter(superview))
            ]
        } else {
            return [
                minorEdgeMinimum(sizedView.view).constraint(equalTo: minorEdgeMinimum(superview), constant: minorPadding.0).with(priority: .for(.stackItemMinorEdgeAnchors)),
                minorEdgeMaximum(sizedView.view).constraint(equalTo: minorEdgeMaximum(superview), constant: -minorPadding.1).with(priority: .for(.stackItemMinorEdgeAnchors))
            ]
        }
    }
    // swiftlint:enable function_parameter_count
}
