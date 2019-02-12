//
//  HorizontalStackViewController.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit
import Neatly

final class HorizontalStackViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .gray
        self.automaticallyAdjustsScrollViewInsets = false

        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let scrollView = UIScrollView(color: .white)
        let container = UIView()

        self.view.neatly
            .add(view: scrollView)
            .anchored(to: [.left, .right], insets: insets)

        self.view.neatly
            .layout(subview: scrollView)
            .anchored(top: self.topLayoutGuide.bottomAnchor, left: nil, bottom: self.bottomLayoutGuide.topAnchor, right: nil, insets: insets)

        scrollView.neatly
            .add(view: container)
            .anchored(to: .all)
        container.heightAnchor.constraint(equalTo: scrollView.heightAnchor).activate()

        let subviews = Array(count: 8) { UIView(color: .random()) }

        container.neatly
            .add(views: subviews)
            .with(format: .stack(
                axis: .horizontal,
                spacing: 20,
                insets: insets)
        )

        subviews.forEach {
            $0.widthAnchor.constraint(equalToConstant: 100).activate()
        }
    }
}
