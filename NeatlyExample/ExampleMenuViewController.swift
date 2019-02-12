//
//  ExampleMenuViewController.swift
//  Domain
//
//  Created by Sam.Warner on 29/6/17.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import UIKit
import Neatly

final class ExampleMenuViewController: UIViewController {

    typealias OnItemTap = () -> Void

    private final class ItemView: UIView {

        let label = UILabel()
        let chevron = UIImageView()

        let onTap: OnItemTap

        init(label: String, onTap: @escaping OnItemTap) {
            self.onTap = onTap

            super.init(frame: .zero)

            self.label.text = label

            self.neatly
                .add(views: [self.label, self.chevron])
                .with(format: .stack(axis: .horizontal, spacing: 0, insets: .zero))

            self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapped)))
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        @objc private func tapped() {
            self.onTap()
        }
    }

    private lazy var items: [(label: String, onTap: OnItemTap)] = {
        [
            (".stack(axis: .vertical, ...)", { self.push(viewController: VerticalStackViewController()) }),
            (".stack(axis: .vertical, ...) with fixed sizes", { self.push(viewController: FixedSizeVerticalStackViewController()) }),
            (".stack(axis: .horizontal, ...)", { self.push(viewController: HorizontalStackViewController()) }),
            (".table(...)", { self.push(viewController: TableViewController()) }),
            (".table(...) with fixed sizes", { self.push(viewController: FixedSizeTableViewController()) }),
            ("Custom layout extensions", { self.push(viewController: VerticalStackViewController()) })
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        let insets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let container = UIView(color: .white)

        self.view.neatly
            .add(view: container)
            .anchored(to: [.left, .right], insets: insets)

        self.view.neatly
            .layout(subview: container)
            .anchored(top: self.topLayoutGuide.bottomAnchor, left: nil, bottom: self.bottomLayoutGuide.topAnchor, right: nil, insets: insets)

        container.neatly
            .add(sizedViews: items.map { SizedView(view: ItemView(label: $0.label, onTap: $0.onTap), height: 44) })
            .with(format: .stack(axis: .vertical, spacing: 0, insets: .zero))
    }

    private func push(viewController: UIViewController) {
        self.navigationController!.pushViewController(viewController, animated: true)
    }
}
