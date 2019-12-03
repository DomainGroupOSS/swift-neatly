//
//  UIViewCompatibleSafeAreaExtensions.swift
//  Neatly
//
//  Created by Sam.Warner on 7/3/18.
//  Copyright © 2018 Fairfax Digital. All rights reserved.
//

import UIKit

public extension UIView {

    @available(iOS, deprecated: 11.0, message: "Use safeAreaInsets")
    var supportedSafeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return .zero
        }
    }

    private static var layoutGuideKey: UInt8 = 0

    @available(iOS, deprecated: 11.0, message: "Use safeAreaLayoutGuide")
    var compatibilitySafeAreaLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide
        } else {
            if let existingLayoutGuide = objc_getAssociatedObject(self, &UIView.layoutGuideKey) as? UILayoutGuide {
                return existingLayoutGuide
            } else {
                let layoutGuide = UILayoutGuide()

                self.addLayoutGuide(layoutGuide)
                layoutGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                layoutGuide.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                layoutGuide.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                layoutGuide.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

                objc_setAssociatedObject(self, &UIView.layoutGuideKey, layoutGuide, .OBJC_ASSOCIATION_RETAIN)

                return layoutGuide
            }
        }
    }
}

public extension UIViewController {

    private static var layoutGuideKey: UInt8 = 0

    @available(iOS, deprecated: 11.0, message: "Use view.safeAreaLayoutGuide")
    var compatibilitySafeAreaLayoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return self.view.safeAreaLayoutGuide
        } else {
            if let existingLayoutGuide = objc_getAssociatedObject(self, &UIViewController.layoutGuideKey) as? UILayoutGuide {
                return existingLayoutGuide
            } else {
                let layoutGuide = UILayoutGuide()

                self.view.addLayoutGuide(layoutGuide)
                layoutGuide.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
                layoutGuide.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
                layoutGuide.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor).isActive = true
                layoutGuide.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true

                objc_setAssociatedObject(self, &UIViewController.layoutGuideKey, layoutGuide, .OBJC_ASSOCIATION_RETAIN)

                return layoutGuide
            }
        }
    }
}
