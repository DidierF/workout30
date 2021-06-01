//
//  ExcerciseCell.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit

class ExcerciseCell: UITableViewCell {
    static let identifier = String(describing: ExcerciseCell.self)

    var isCurrent: Bool = false

    lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Excercise"
        return l
    }()

    var heightConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(style: .default, reuseIdentifier: ExcerciseCell.identifier)
        setupView()
    }

    private func setupView() {
        contentView.addSubviews([label])
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 44)
        heightConstraint!.priority = .defaultLow
        NSLayoutConstraint.activate([
            heightConstraint!,
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16)
        ])
    }

    func setTitle(_ title: String, isCurrent: Bool) {
        self.isCurrent = isCurrent
        self.label.text = title
        contentView.backgroundColor = isCurrent ? .darkGray : .white
        heightConstraint?.constant = isCurrent ? 80 : 44
    }
}
