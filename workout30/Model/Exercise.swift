//
//  Exercise.swift
//  workout30
//
//  Created by Didier on 5/6/21.
//

import Foundation

class Exercise: CustomStringConvertible {
    var name: String = ""
    var time: Int = 0
    var image: String = ""
    var rest: Int = 0

    public var description: String {
        return "\(name)"
    }
}
