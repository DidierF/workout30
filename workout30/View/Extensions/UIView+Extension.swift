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
}
