//
//  AnchoredEdges.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

struct AnchoredLayout {

    let topAnchor: NSLayoutYAxisAnchor?
    let leftAnchor: NSLayoutXAxisAnchor?
    let bottomAnchor: NSLayoutYAxisAnchor?
    let rightAnchor: NSLayoutXAxisAnchor?

    let insets: UIEdgeInsets
}

extension AnchoredLayout {

    init(edges: UIRectEdge, to superviewEdges: Layout.Edges, insets: UIEdgeInsets) {
        self.topAnchor = edges.contains(.top) ? superviewEdges.topAnchor : nil
        self.leftAnchor = edges.contains(.left) ? superviewEdges.leftAnchor : nil
        self.bottomAnchor = edges.contains(.bottom) ? superviewEdges.bottomAnchor : nil
        self.rightAnchor = edges.contains(.right) ? superviewEdges.rightAnchor : nil

        self.insets = insets
    }
}

extension AnchoredLayout {

    public func prepare(sizedView: SizedView) -> [NSLayoutConstraint] {
        let view = sizedView.view
        let edges = [
            self.topAnchor.map { view.topAnchor.constraint(equalTo: $0, constant: insets.top) },
            self.leftAnchor.map { view.leftAnchor.constraint(equalTo: $0, constant: insets.left) },
            self.bottomAnchor.map { view.bottomAnchor.constraint(equalTo: $0, constant: -insets.bottom) },
            self.rightAnchor.map { view.rightAnchor.constraint(equalTo: $0, constant: -insets.right) }
        ]
        let dimensions = [
            sizedView.width.map { view.widthAnchor.constraint(equalToConstant: $0) },
            sizedView.height.map { view.heightAnchor.constraint(equalToConstant: $0) }
        ]
        return (edges + dimensions).compactMap { $0 }
    }
}
