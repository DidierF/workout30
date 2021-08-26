//
//  SettingsViewController.swift
//  workout30
//
//  Created by Didier on 26/8/21.
//

import UIKit

class SettingsViewController: UIViewController {

    lazy var tableView: UITableView = {
        let t = UITableView()

        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()

    override func viewDidLoad() {
        view.backgroundColor = .white
        title = "Settings"

        view.addSubviews([tableView])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

}
