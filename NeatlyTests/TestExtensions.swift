//
//  TestExtensions.swift
//  Neatly
//
//  Created by Aiden Benton on 7/02/2017.
//  Copyright © 2017 Domain. All rights reserved.
//

import Neatly

extension Array {

    static func array(count: Int, valueInitializer: () -> Element, incorporatingArray array: [Element]) -> [Element] {
        if array.count < count {
            return self.array(count: count, valueInitializer: valueInitializer, incorporatingArray: array + [valueInitializer()])
        } else {
            return array
        }
    }

    init(count: Int, valueInitializer: () -> Element) {
        self.init(Array.array(count: count, valueInitializer: valueInitializer, incorporatingArray: []))
    }
}

extension UIEdgeInsets {

    init(_ inset: CGFloat, on edges: UIRectEdge = .all) {
        self.init(
            top: edges.contains(.top) ? inset : 0,
            left: edges.contains(.left) ? inset : 0,
            bottom: edges.contains(.bottom) ? inset : 0,
            right: edges.contains(.right) ? inset : 0
        )
    }
}
