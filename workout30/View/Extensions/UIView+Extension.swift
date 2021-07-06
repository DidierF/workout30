//
//  UIView+Extension.swift
//  workout30
//
//  Created by Didier on 1/6/21.
//

import UIKit

extension UIView {
    func addSubviews(_ children: [UIView]) {
        for v in children {
            addSubview(v)
        }
    }

    func addShadow(offset: CGFloat = 4) {
        layer.shadowColor = CGColor(gray: 0, alpha: 1)
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: offset)
    }
}
