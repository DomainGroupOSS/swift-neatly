//
//  ArrayValueInitializer.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import Foundation

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
