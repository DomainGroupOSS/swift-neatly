//
//  ConstraintContaining.swift
//  Domain
//
//  Created by Aiden Benton on 21/02/2017.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

public protocol ConstraintDescribing {

    func activate()
    func deactivate()

    func update(constant: CGFloat)
}

/**
 A container for layout state, providing the following methods:
 
 - `install`
 - `uninstall`
 - `activate`
 - `deactivate`
 */
public protocol ConstraintContaining {

    associatedtype Constraint: ConstraintDescribing

    var constraints: [Constraint] { get }
}

public extension ConstraintContaining {
    
    public func activate() {
        self.constraints.forEach { $0.activate() }
    }
    
    public func deactivate() {
        self.constraints.forEach { $0.deactivate() }
    }
    
    public func update(active: Bool) {
        if active {
            self.activate()
        } else {
            self.deactivate()
        }
    }
}
