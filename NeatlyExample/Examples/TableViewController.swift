//
//  TableViewController.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit
import Neatly

final class TableViewController: UIViewController {

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
            .anchored(top: self.topLayoutGuide.bottomAnchor, left: nil, bottom: self.bottomLayoutGuide.topAnchor, right: nil, insets: insets)

        let subviews = Array(count: 10) { UIView(color: .random()) }

        subviews.forEach {
            $0.heightAnchor.constraint(equalToConstant: 60).activate()
        }

        container.neatly
            .add(views: subviews)
            .with(format: .table(
                columns: 3,
                horizontalSpacing: 10,
                verticalSpacing: 10,
                insets: insets)
        )
    }
}
