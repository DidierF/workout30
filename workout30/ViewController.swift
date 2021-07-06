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

    var exercises: [Exercise] = []
    var selected = -1
    var currentSet = 1
    var state: ExerciseState = .NotStarted {
        didSet {
            switch state {
                case .Running:
                    break
                case .Resting:
                    break
                default:
                    break
            }
        }
    }

    let strings = L10n.Workout.self
    let storage = Storage.storage()

    var auto = false {
        didSet {
        }
    }
    var sets = 2

    @objc private func toggleAuto() {
        print(state)
        if state == .NotStarted {
            auto = !auto
        }
    }

    lazy var currentExercise: ExerciseView = {
        let size: CGFloat = 272
        let e = ExerciseView(radius: size/2)
        NSLayoutConstraint.activate([
            e.heightAnchor.constraint(equalToConstant: size),
            e.widthAnchor.constraint(equalToConstant: size)
        ])
        e.backgroundColor = .white

        return e
    }()

    lazy var playButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(Asset.Images.play.image, for: .normal)
        NSLayoutConstraint.activate([
            b.heightAnchor.constraint(equalToConstant: 100),
            b.widthAnchor.constraint(equalToConstant: 100)
        ])
        b.layer.cornerRadius = 50
        b.addShadow()

        b.backgroundColor = .white
        return b
    }()

    lazy var exerciseTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 34)
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.lineBreakMode = .byTruncatingTail
        l.textAlignment = .center

        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = strings.title
        WorkoutService().getWorkout(completion: refreshWorkout)
        auto = false

        view.addSubviews([exerciseTitle, currentExercise, playButton])
        NSLayoutConstraint.activate([
            exerciseTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            exerciseTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            exerciseTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),

            currentExercise.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentExercise.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
        
    }

    override func viewWillLayoutSubviews() {
        view.backgroundColor = Asset.Colors.background.color
    }

    private func refreshWorkout(_ newExercises: [Exercise]) {
        self.exercises = newExercises
        refreshViews()
    }

    private func refreshViews() {
        let main = exercises[0]
        currentExercise.image.sd_setImage(with: storage.reference(withPath: main.image), placeholderImage: nil)
        exerciseTitle.text = main.name
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
        } else if (selected == exercises.count - 1) {
            if currentSet == sets {
                state = .NotStarted
                selected = -1
                currentSet = 1
            } else {
                currentSet += 1
                selected = 0
                state = .Running
            }
        } else {
            state = .Running
            selected += 1
        }
    }

    @objc private func onTimerEnd() {
        if auto {
            cycleExercise()
        }
    }

}
