//
//  FixedSizeVerticalStackViewController.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit
import Neatly

final class FixedSizeVerticalStackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .gray

        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let container = UIView(color: .white)

        self.view.neatly
            .add(view: container)
            .anchored(to: [.left, .right], insets: insets)

        self.view.neatly
            .layout(subview: container)
            .anchored(top: self.topLayoutGuide.bottomAnchor, left: nil, bottom: nil, right: nil, insets: insets)

        let selfSizedSubviews = Array(count: 2) { UIView(color: .red) }
        
        selfSizedSubviews.forEach {
            $0.heightAnchor.constraint(equalToConstant: 44).activate()
        }

        let fixedHeightSubviews = Array(count: 2) { UIView(color: .blue) }

        let fixedSizeSubviews = Array(count: 2) { UIView(color: .purple) }

        let subviews =
            selfSizedSubviews.map { SizedView(view: $0) } +
            fixedHeightSubviews.map { SizedView(view: $0, height: .random(in: 20...50)) } +
            fixedSizeSubviews.map { SizedView(view: $0, width: .random(in: 100...300), height: .random(in: 20...50)) }

        container.neatly
            .add(sizedViews: subviews)
            .with(format: .stack(
                axis: .vertical,
                spacing: 20,
                insets: insets)
        )
    }
}
