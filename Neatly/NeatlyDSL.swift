//
//  Layouts.swift
//  Domain
//
//  Created by Aiden Benton on 10/02/2017.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

public struct Layout {

    public struct Edges {
        public let topAnchor: NSLayoutYAxisAnchor
        public let leftAnchor: NSLayoutXAxisAnchor
        public let bottomAnchor: NSLayoutYAxisAnchor
        public let rightAnchor: NSLayoutXAxisAnchor
    }
}

public struct NeatlyDSL {

    private let view: UIView
    private let edges: () -> Layout.Edges
    
    init(view: UIView, edges: @escaping () -> Layout.Edges) {
        self.view = view
        self.edges = edges
    }

    @discardableResult
    public func add(view subview: UIView) -> Layout.Anchorer {
        return self.add(sizedView: SizedView(view: subview))
    }

    public func add(sizedView sizedSubview: SizedView) -> Layout.Anchorer {
        self.view.addSubview(sizedSubview.view)
        return self.layout(sizedSubview: sizedSubview)
    }

    @discardableResult
    public func add(views subviews: [UIView]) -> Layout.Constructor {
        return self.add(sizedViews: subviews.map { SizedView(view: $0) })
    }

    public func add(sizedViews sizedSubviews: [SizedView]) -> Layout.Constructor {
        sizedSubviews.forEach { sizedSubview in
            self.view.addSubview(sizedSubview.view)
        }
        return self.layout(sizedSubviews: sizedSubviews)
    }

    public func layout(subview: UIView) -> Layout.Anchorer {
        return self.layout(sizedSubview: SizedView(view: subview))
    }

    public func layout(sizedSubview: SizedView) -> Layout.Anchorer {
        return Layout.Anchorer(edges: self.edges(), sizedSubview: sizedSubview)
    }

    public func layout(subviews: [UIView]) -> Layout.Constructor {
        return self.layout(sizedSubviews: subviews.map { SizedView(view: $0) })
    }

    public func layout(sizedSubviews: [SizedView]) -> Layout.Constructor {
        return Layout.Constructor(superview: self.view, sizedSubviews: sizedSubviews)
    }
}

public extension UIView {

    var neatly: NeatlyDSL {
        return NeatlyDSL(view: self, edges: { Layout.Edges(
            topAnchor: self.topAnchor,
            leftAnchor: self.leftAnchor,
            bottomAnchor: self.bottomAnchor,
            rightAnchor: self.rightAnchor
        )})
    }
}

public extension UIViewController {

    var neatly: NeatlyDSL {
        return NeatlyDSL(view: self.view, edges: { Layout.Edges(
            topAnchor: self.compatibilitySafeAreaLayoutGuide.topAnchor,
            leftAnchor: self.compatibilitySafeAreaLayoutGuide.leftAnchor,
            bottomAnchor: self.compatibilitySafeAreaLayoutGuide.bottomAnchor,
            rightAnchor: self.compatibilitySafeAreaLayoutGuide.rightAnchor
        )})
    }
}
