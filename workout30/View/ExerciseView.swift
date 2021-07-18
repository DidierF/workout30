//
//  ExerciseView.swift
//  workout30
//
//  Created by Didier on 6/7/21.
//

import UIKit

class ExerciseView: UIView {

    lazy var image: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.clipsToBounds = true
        return i
    }()

    lazy var container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        return v
    }()

    lazy private var exerciseRing: TimerRing = {
        return TimerRing(center: CGPoint(x: rad, y: rad), radius: rad)
    }()

    var exercisePercentage: CGFloat {
        set {
            exerciseRing.strokeEnd = newValue
        }

        get {
            exerciseRing.strokeEnd
        }
    }

    lazy private var workoutRing: TimerRing = {
        let ring = TimerRing(center: CGPoint(x: rad, y: rad), radius: rad + 16)
        ring.strokeColor = UIColor.green.cgColor
        return ring
    }()

    var workoutPercentage: CGFloat {
        set {
            workoutRing.strokeEnd = newValue
        }

        get {
            workoutRing.strokeEnd
        }
    }

    var rad: CGFloat = 0

    init(radius: CGFloat) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addShadow()

        rad = radius

        layer.addSublayer(exerciseRing)
        layer.addSublayer(workoutRing)

        layer.cornerRadius = radius
        clipsToBounds = false

        container.layer.cornerRadius = radius
        container.addSubview(image)

        addSubview(container)
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),
            container.leftAnchor.constraint(equalTo: leftAnchor),
            container.rightAnchor.constraint(equalTo: rightAnchor),

            image.topAnchor.constraint(equalTo: container.topAnchor),
            image.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            image.leftAnchor.constraint(equalTo: container.leftAnchor),
            image.rightAnchor.constraint(equalTo: container.rightAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
