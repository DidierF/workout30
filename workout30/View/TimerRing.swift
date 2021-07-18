//
//  TimerRing.swift
//  workout30
//
//  Created by Didier on 17/7/21.
//

import UIKit

class TimerRing: CAShapeLayer {
    init(center: CGPoint, radius: CGFloat, lineWidth: CGFloat = 12) {
        super.init()
        let circularPath = UIBezierPath(arcCenter: center, radius: radius + lineWidth / 2 + 4,
                                        startAngle: -(.pi/2), endAngle: .pi * 1.5, clockwise: true)
        path = circularPath.cgPath
        strokeColor = UIColor.blue.cgColor
        self.lineWidth = lineWidth
        fillColor = UIColor.clear.cgColor
        strokeEnd = 0
        lineCap = .round
    }

    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
