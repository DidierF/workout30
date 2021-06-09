//
//  ExcerciseCell.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit

class ExerciseCell: UITableViewCell {
    static let identifier = String(describing: ExerciseCell.self)
    lazy var timer: Timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
        self.time -= 1
    })

    var state: ExerciseState = .NotStarted {
        didSet {
            switch state {
            case .NotStarted:
                backgroundColor = .white
                label.textColor = .black
            case .Running:
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.time -= 1
                })
                timer.fire()
                backgroundColor = .systemGreen
            case .Resting:
                label.text = L10n.Exercise.rest
                time = 10
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
                    self.time -= 1
                })
                timer.fire()
            case .Ended:
                backgroundColor = .lightGray
                label.textColor = .white
                _time.textColor = .white
                timer.invalidate()
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

            _time.text = String(format:"%02d:%02d", minutes, seconds)
            if time == 0 {
                timer.invalidate()
                if state == .Running {
                    state = .Resting
                }
            }

        }
    }

    private lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = L10n.Exercise.exercise
        return l
    }()

    private lazy var _time: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "00:00"
        l.textAlignment = .right
        return l
    }()

    private lazy var divider: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        let c: CGFloat = 0.9
        v.backgroundColor = .init(red: c, green: c, blue: c, alpha: 1)
        return v
    }()

    lazy var image: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.backgroundColor = .blue
        return i
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: ExerciseCell.identifier)
        setupView()
    }

    private func setupView() {
        contentView.addSubviews([label, _time, image, divider])
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            image.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            image.heightAnchor.constraint(equalToConstant: 200),

            label.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 24),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            _time.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            _time.leftAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            _time.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            divider.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func cycleState() {
        switch state {
        case .NotStarted:
            state = .Running
        default:
            state = .Ended
        }
    }
}
