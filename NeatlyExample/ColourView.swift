//
//  ColourView.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

extension UIView {

    convenience init(color: UIColor) {
        self.init(frame: .zero)

        self.backgroundColor = color
    }
}
