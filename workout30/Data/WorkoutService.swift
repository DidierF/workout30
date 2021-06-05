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
        plank.image = "https://firebasestorage.googleapis.com/v0/b/workout30-94571.appspot.com/o/hollow-plank.jpeg?alt=media&token=6d08220f-fd8f-4f37-bfcd-5fc21a3bced9"
        plank.time = 20
        plank.rest = 10
        return [
            plank
        ]
    }
}
