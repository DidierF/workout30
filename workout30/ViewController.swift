//
//  ViewController.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit

class ViewController: UIViewController {

    let excercises = [
        "ex 1", "ex 2", "ex 3", "ex 4"
    ]
    var selected = 0

    lazy var nextButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 80).isActive = true
        b.setTitle("Next", for: .normal)
        b.addTarget(self, action: #selector(onNextPress), for: .touchUpInside)
        b.backgroundColor = UIColor.init(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 1)

        return b
    }()

    lazy var table: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.separatorColor = .clear
        t.register(ExcerciseCell.self, forCellReuseIdentifier: ExcerciseCell.identifier)
        return t
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Workout"

        view.addSubviews([nextButton, table])

        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            table.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            nextButton.topAnchor.constraint(equalTo: table.bottomAnchor),
            nextButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }

    @objc private func onNextPress() {
        if (selected < excercises.count - 1) {
            selected += 1
            table.reloadData()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: ExcerciseCell.identifier) ?? ExcerciseCell()) as! ExcerciseCell
        cell.setTitle(excercises[indexPath.row], isCurrent: indexPath.row == selected)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        excercises.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

