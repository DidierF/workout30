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
    let play = Asset.Images.play.image
    let pause = Asset.Images.pause.image
    let rest = Asset.Images.rest.image

    var auto = true
    var sets = 1

    var timer: Timer?
    private var time: Int = 0 {
        didSet {
            if time == 0 {
                timer?.invalidate()
                onTimerEnd()
            }
            refreshViews()
        }
    }

    @objc private func toggleAuto() {
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

    lazy var playButton: ActionButton = {
        let b = ActionButton(size: 100)
        b.icon = play
        b.addTarget(self, action: #selector(onNextPress), for: .touchUpInside)
        return b
    }()

    let exerciseTitle: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 34)
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.lineBreakMode = .byTruncatingTail
        l.textAlignment = .center

        return l
    }()

    let timerLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 20)
        l.numberOfLines = 1
        l.textAlignment = .center
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = strings.title
        WorkoutService().getWorkout(completion: refreshWorkout)

        view.addSubviews([exerciseTitle, currentExercise, playButton, timerLabel])
        NSLayoutConstraint.activate([
            exerciseTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            exerciseTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            exerciseTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),

            currentExercise.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentExercise.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: currentExercise.bottomAnchor, constant: 24),

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
        let main = selected == -1 ? exercises[0] : exercises[selected]
        currentExercise.image.sd_setImage(with: storage.reference(withPath: main.image), placeholderImage: nil)
        exerciseTitle.text = main.name
        timerLabel.text = L10n.Exercise.timer(time/60, time%60)
    }

    @objc private func onNextPress() {
        if !auto || state == .NotStarted {
            cycleExercise()
            return
        }
        pauseTimer()
    }

    private func cycleExercise() {
        if (state == .Running) {
            state = .Resting
            resetTimer(with: exercises[selected].rest)
            playButton.icon = play
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
            resetTimer(with: exercises[selected].time)
            playButton.icon = auto ? pause : rest
        }
    }

    private func resetTimer(with time: Int? = nil) {
        if time != nil {
            self.time = time! + 1
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            self?.time -= 1
        })
        timer?.fire()
    }

    private func onTimerEnd() {
        if auto {
            cycleExercise()
        }
    }

    private func pauseTimer() {
        if timer?.isValid ?? false {
            timer?.invalidate()
            playButton.icon = play
        } else {
            resetTimer()
            playButton.icon = pause
        }
    }

}
