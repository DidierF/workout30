//
//  ExcerciseCell.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit

class ExerciseCell: UITableViewCell {
    static let identifier = String(describing: ExerciseCell.self)
    lazy var timer: Timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
        self?.time -= 1
    })
    let animationTime = 0.2
    var state: ExerciseState = .NotStarted {
        didSet {
            timer.invalidate()
            switch state {
            case .NotStarted:
                imageHeight.constant = 0
            case .Running:
                setTimer()
                imageHeight.constant = 100
                timer.fire()
            case .Resting:
                label.text = L10n.Exercise.rest

                setTimer()
                timer.fire()
            case .Ended:
                imageHeight.constant = 0
            }
        }
    }

    var title: String {
        set {
            label.text = newValue
        }
        get {
            label.text ?? ""
        }
    }

    var time: Int = 0 {
        didSet {
            let seconds = time % 60
            let minutes = time / 60

            _time.text = String(format:L10n.Exercise.timer(minutes, seconds), minutes, seconds)
            if time == 0 {
                timer.invalidate()
                onTimerEnd?()
            }

        }
    }

    private lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = L10n.Exercise.exercise
        l.textColor = Asset.Colors.text.color
        return l
    }()

    private lazy var _time: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .right
        l.textColor = Asset.Colors.text.color
        return l
    }()

    private lazy var divider: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Asset.Colors.divider.color
        return v
    }()

    lazy var image: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.backgroundColor = .clear
        return i
    }()

    private lazy var imageHeight: NSLayoutConstraint = {
        image.heightAnchor.constraint(equalToConstant: 0)
    }()

    public var onTimerEnd: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: ExerciseCell.identifier)
        setupView()
    }

    private func setupView() {
        backgroundColor = .clear
        contentView.addSubviews([label, _time, image, divider])
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            image.widthAnchor.constraint(equalToConstant: 200),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageHeight,

            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: divider.bottomAnchor, constant: -8),

            _time.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            _time.leftAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            _time.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            divider.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            divider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            if self?.time ?? 0 > 0 {
                self?.time -= 1
            }
        })
    }
}
