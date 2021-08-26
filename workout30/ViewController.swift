//
//  ViewController.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit
import FirebaseStorage
import FirebaseUI
import AVFoundation

class ViewController: UIViewController {

    var exercises: [Exercise] = []
    var selected = -1
    var currentSet = 1

    var auto = true
    var sets = 1

    var startSound = Asset.Sounds.start.data
    var restSound = Asset.Sounds.end.data

    var state: ExerciseState = .NotStarted {
        didSet {
            handleStateChange(state)
        }
    }

    let strings = L10n.Workout.self
    let storage = Storage.storage()
    let play = Asset.Images.play.image
    let pause = Asset.Images.pause.image
    let rest = Asset.Images.rest.image

    let buttonMargin = (UIScreen.main.bounds.width - 200) / 4

    var timer: Timer?
    private var time: Int = 0 {
        didSet {
            refreshViews()
            if time < 0 {
                timer?.invalidate()
                onTimerEnd()
            }
        }
    }

    @objc private func toggleAuto() {
        if state == .NotStarted {
            auto = !auto
        }
    }

    lazy var currentExercise: ExerciseView = {
        let size: CGFloat = 272
        let e = ExerciseView(size: size)
        e.backgroundColor = .white
        return e
    }()

    lazy var nextExercise: ExerciseView = {
        let size: CGFloat = 150
        let e = ExerciseView(size: size)
        e.layer.opacity = 0.5
        return e
    }()

    lazy var playButton: ActionButton = {
        let b = ActionButton(size: 100)
        b.icon = play
        b.addTarget(self, action: #selector(onNextPress), for: .touchUpInside)
        return b
    }()

    lazy var settings: ActionButton = {
        let b = ActionButton(size: 50)
        b.icon = Asset.Images.gear.image
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
        l.textColor = .black

        return l
    }()

    let timerLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 20)
        l.numberOfLines = 1
        l.textAlignment = .center
        l.textColor = .black
        return l
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = strings.title
        WorkoutService().getWorkout(completion: refreshWorkout)
        view.backgroundColor = Asset.Colors.background.color

        let screenW = UIScreen.main.bounds.width

        view.addSubviews([nextExercise, exerciseTitle, currentExercise, playButton, timerLabel, settings])
        NSLayoutConstraint.activate([
            exerciseTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            exerciseTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            exerciseTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),

            nextExercise.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: screenW/4),
            nextExercise.topAnchor.constraint(equalTo: exerciseTitle.bottomAnchor, constant: 16),

            currentExercise.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentExercise.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),

            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: currentExercise.bottomAnchor, constant: 36),

            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),

            settings.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            settings.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: buttonMargin + 25),
        ])
    }

    private func refreshWorkout(_ newExercises: [Exercise]) {
        self.exercises = newExercises
        refreshViews()
    }

    private func refreshViews() {
        let mainIndex = selected == -1 ? 0 : selected
        let main = exercises[mainIndex]
        currentExercise.image.sd_setImage(with: storage.reference(withPath: main.image), placeholderImage: nil)
        if mainIndex < exercises.count - 1 {
            let next = exercises[mainIndex+1]
            nextExercise.image.sd_setImage(with: storage.reference(withPath: next.image))
            nextExercise.isHidden = false
        } else {
            nextExercise.isHidden = true
        }
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
        } else if (selected == exercises.count - 1) {
            if currentSet == sets {
                state = .Ended
            } else {
                currentSet += 1
                selected = 0
                state = .Running
            }
        } else {
            state = .Running
        }
    }

    private func resetTimer(with time: Int? = nil) {
        if time != nil {
            self.time = time! + 1
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.time -= 1
            self.currentExercise.exercisePercentage = self.loadingPercentage
        })
        timer?.fire()
    }

    private var loadingPercentage: CGFloat {
        switch self.state {
        case .Running:
            let total: CGFloat = CGFloat(self.exercises[self.selected].time)
            return 1 - (CGFloat(self.time) / total)
        case .Resting:
            let total: CGFloat = CGFloat(self.exercises[self.selected].rest)
            return (CGFloat(self.time) / total)
        default:
            return 0
        }
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

    var player: AVAudioPlayer?

    private func playSound(_ soundData: Data) {
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            /// change fileTypeHint according to the type of your audio file (you can omit this)

//            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)
            player = try AVAudioPlayer(data: soundData, fileTypeHint: "wav")

            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }

}

extension ViewController {
    private func handleStateChange(_ newState: ExerciseState) {
        switch state {
        case .Running:
            playSound(startSound.data)
            selected += 1
            resetTimer(with: exercises[selected].time)
            currentExercise.workoutPercentage = CGFloat(selected) * CGFloat(currentSet) / CGFloat(exercises.count) * CGFloat(sets)
            playButton.icon = auto ? pause : rest
        case .Resting:
            playSound(restSound.data)
            resetTimer(with: exercises[selected].rest)
            if !auto {
                playButton.icon = play
            }
        case .Ended:
            currentExercise.workoutPercentage = 1
            state = .NotStarted
        case .NotStarted:
            selected = -1
            currentSet = 1
            time = 0
            timer?.invalidate()
            playButton.icon = play
        }
    }
}
