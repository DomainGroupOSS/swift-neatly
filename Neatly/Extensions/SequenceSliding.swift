//
//  SequenceSliding.swift
//  Domain
//
//  Created by Sam.Warner on 28/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

internal extension Sequence {

    func sliding() -> Zip2Sequence<Self, AnySequence<Self.Iterator.Element>> {
        // FIXME: dropFirst not working due to SubSequence conversion
        return zip(self, AnySequence(self.enumerated().filter { index, _ in index != 0 }.map { $0.element }))
    }
}
