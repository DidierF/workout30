//
//  Button.swift
//  workout30
//
//  Created by Didier on 12/7/21.
//

import UIKit

class ActionButton: UIButton {
    var icon: UIImage? {
        didSet {
            self.setImage(icon, for: .normal)
        }
    }
    init(size: CGFloat) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = size / 2
        addShadow()
        backgroundColor = .white
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size),
            widthAnchor.constraint(equalToConstant: size)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
