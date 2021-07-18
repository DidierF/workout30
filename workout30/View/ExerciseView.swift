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

    lazy var exerciseRing: CAShapeLayer = {
        let circle = CAShapeLayer()
        let width: CGFloat = 12
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: rad, y: rad), radius: rad + width/2 + 4, startAngle: -(.pi/2), endAngle: .pi * 1.5, clockwise: true)
        circle.path = circularPath.cgPath
        circle.strokeColor = UIColor.blue.cgColor
        circle.lineWidth = width
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeEnd = 0
        circle.lineCap = .round

        return circle
    }()

    var rad: CGFloat = 0

    init(radius: CGFloat) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addShadow()

        rad = radius

        layer.addSublayer(exerciseRing)

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

    func updateBorderTo(_ percentage: CGFloat) {
        UIView.animate(withDuration: 1, animations: {
            self.exerciseRing.strokeEnd = percentage
            self.layoutIfNeeded()
        })
    }
}
