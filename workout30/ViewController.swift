//
//  ViewController.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit
import FirebaseStorage
import FirebaseUI

class ViewController: UIViewController {

    var excercises: [Exercise] = []
    var selected = -1
    var currentSet = 1
    var state: ExerciseState = .NotStarted {
        didSet {
            switch state {
                case .Running:
                    nextButton.setTitle(strings.Button.rest, for: .normal)
                case .Resting:
                    if (selected == excercises.count - 1) {
                        nextButton.setTitle(strings.Button.finish, for: .normal)
                        break
                    }
                    nextButton.setTitle(strings.Button.next, for: .normal)
                default:
                    nextButton.setTitle(strings.Button.start, for: .normal)
            }
        }
    }

    let strings = L10n.Workout.self
    let storage = Storage.storage()

    var auto = false {
        didSet {
            navigationItem.rightBarButtonItem?.tintColor = auto ? Asset.toggleOn.color : Asset.toggleOff.color
        }
    }
    var sets = 2

    lazy var nextButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 80).isActive = true
        b.setTitle(strings.Button.start, for: .normal)
        b.addTarget(self, action: #selector(onNextPress), for: .touchUpInside)
        b.backgroundColor = Asset.button.color
        b.titleLabel?.textColor = Asset.buttonText.color

        return b
    }()

    lazy var table: UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.delegate = self
        t.dataSource = self
        t.backgroundColor = .clear
        t.separatorColor = .clear
        t.register(ExerciseCell.self, forCellReuseIdentifier: ExerciseCell.identifier)
        return t
    }()

    @objc private func toggleAuto() {
        print(state)
        if state == .NotStarted {
            auto = !auto
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = strings.title
        WorkoutService().getWorkout(completion: refreshWorkout)

        view.addSubviews([nextButton, table])

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: strings.Button.auto, style: .plain, target: self, action: #selector(toggleAuto))
        auto = false

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

    override func viewWillLayoutSubviews() {
        view.backgroundColor = Asset.background.color
    }

    private func refreshWorkout(_ newExercises: [Exercise]) {
        self.excercises = newExercises
        self.table.reloadData()
    }

    @objc private func onNextPress() {
        if !auto {
            cycleExercise()
            return
        }
    }

    private func cycleExercise() {
        if (state == .Running) {
            state = .Resting
        } else if (selected == excercises.count - 1) {
            if currentSet == sets {
                nextButton.isHidden = false
                state = .NotStarted
                selected = -1
                currentSet = 1
            } else {
                currentSet += 1
                selected = 0
                state = .Running
            }
        } else {
            nextButton.isHidden = auto
            state = .Running
            selected += 1
        }
        table.reloadData()
    }

    @objc private func onTimerEnd() {
        if auto {
            cycleExercise()
        }
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: ExerciseCell.identifier) ?? ExerciseCell()) as! ExerciseCell
        let row = indexPath.row
        let ex = excercises[row]

        cell.title = ex.name
        cell.time = row == selected && state == .Resting ? ex.rest : ex.time
        let imgReference = storage.reference(withPath: ex.image)
        cell.image.sd_setImage(with: imgReference, placeholderImage: nil)
        if row == selected {
            cell.state = state
            cell.onTimerEnd = onTimerEnd
        } else if row < selected {
            cell.state = .Ended
        } else {
            cell.state = .NotStarted
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        excercises.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

