//
//  ExcerciseCell.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit

enum ExerciseState {
    case NotStarted
    case Running
    case Ended
}

class ExerciseCell: UITableViewCell {
    static let identifier = String(describing: ExerciseCell.self)

    var isCurrent: Bool = false
    var state: ExerciseState = .NotStarted

    var time: Int {
        set {
            let seconds = newValue % 60
            let minutes = newValue / 60

            _time.text = String(format:"%02d:%02d", minutes, seconds)
        }

        get {
            Int(_time.text ?? "") ?? 0
        }
    }

    private lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Excercise"
        return l
    }()

    private lazy var _time: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "00:00"
        l.textAlignment = .right
        return l
    }()

    var heightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: ExerciseCell.identifier)
        setupView()
    }

    private func setupView() {
        contentView.addSubviews([label, _time])
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 44)
        heightConstraint!.priority = .defaultLow
        NSLayoutConstraint.activate([
            heightConstraint!,
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -8),

            _time.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            _time.leftAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 8),
            _time.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }

    func setTitle(_ title: String, isCurrent: Bool) {
        self.isCurrent = isCurrent
        self.label.text = title
        contentView.backgroundColor = isCurrent ? .darkGray : .white
        heightConstraint?.constant = isCurrent ? 80 : 44
    }
}
