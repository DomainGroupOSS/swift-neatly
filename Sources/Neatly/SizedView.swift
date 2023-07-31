//
//  SizedView.swift
//  Domain
//
//  Created by Sam.Warner on 28/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit

public struct SizedView {
    public let view: UIView
    public let width: CGFloat?
    public let height: CGFloat?

    public init(view: UIView) {
        self.init(view: view, width: nil, height: nil)
    }

    public init(view: UIView, width: CGFloat?) {
        self.init(view: view, width: width, height: nil)
    }

    public init(view: UIView, height: CGFloat?) {
        self.init(view: view, width: nil, height: height)
    }

    public init(view: UIView, width: CGFloat?, height: CGFloat?) {
        self.view = view
        self.width = width
        self.height = height
    }

    public static func expandingSpacer() -> SizedView {
        let spacer = UIView()
        spacer.isHidden = true
        return SizedView(view: spacer)
    }

    public static func fixedSpacer(width: CGFloat? = nil, height: CGFloat? = nil) -> SizedView {
        let spacer = UIView()
        spacer.isHidden = true
        return SizedView(view: spacer, width: width, height: height)
    }
}
