//
//  FixedSizeTableViewController.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit
import Neatly

final class FixedSizeTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .darkGray

        let container = UIView()

        self.view.neatly
            .add(view: container)
            .anchored(to: [.left, .right], insets: .zero)

        self.view.neatly
            .layout(subview: container)
            .anchored(top: self.topLayoutGuide.bottomAnchor, left: nil, bottom: self.bottomLayoutGuide.topAnchor, right: nil, insets: .zero)

        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        container.neatly
            .add(views: [self.fixedSizeContainer, self.inferredSizeContainer])
            .with(format: .stack(axis: .vertical, spacing: 20, insets: insets))
    }

    private lazy var fixedSizeContainer: UIView = {
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let fixedSizeContainer = UIView(color: .white)
        let subviews = Array(count: 14) { UIView(color: .random()) }

        let sizedSubviews = subviews
            .enumerated()
            .map { offset, view -> SizedView in
                switch offset {
                case 2, 6:
                    view.heightAnchor.constraint(equalToConstant: 50).activate()
                    return SizedView(view: view, width: 50)
                case 4, 11:
                    return SizedView(view: view, height: 80)
                default:
                    view.heightAnchor.constraint(equalToConstant: 50).activate()
                    return SizedView(view: view)
                }
        }

        fixedSizeContainer.neatly
            .add(sizedViews: sizedSubviews)
            .with(format: .table(columns: 3, horizontalSpacing: 10, verticalSpacing: 10, insets: insets)
        )

        return fixedSizeContainer
    }()

    private lazy var inferredSizeContainer: UIView = {
        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let inferredSizeContainer = UIView(color: .white)
        let subviews = Array(count: 14) { UIView(color: .random()) }

        subviews
            .enumerated()
            .forEach { offset, view in
                switch offset {
                case 2, 6:
                    view.heightAnchor.constraint(equalToConstant: 50).activate()
                    view.widthAnchor.constraint(equalToConstant: 50).activate()
                case 4, 11:
                    view.heightAnchor.constraint(equalToConstant: 80).activate()
                default:
                    view.heightAnchor.constraint(equalToConstant: 50).activate()
                }
        }

        inferredSizeContainer.neatly
            .add(views: subviews)
            .with(format: .table(columns: 3, horizontalSpacing: 10, verticalSpacing: 10, insets: insets)
        )

        return inferredSizeContainer
    }()
}
