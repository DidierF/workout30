//
//  ExerciseService.swift
//  workout30
//
//  Created by Didier on 5/6/21.
//

import Foundation

class WorkoutService {

    func getWorkout() -> [Exercise] {
        let plank = Exercise()
        plank.name = "Hollow Plank"
        plank.image = "hollow-plank.jpeg"
        plank.time = 20
        plank.rest = 10
        return [
            plank
        ]
    }
}
