//
//  ExerciseService.swift
//  workout30
//
//  Created by Didier on 5/6/21.
//

import Foundation
import FirebaseDatabase

class WorkoutService {

    var exerciseRef = Database.database().reference(withPath: "exercise")

    func getWorkout(completion: @escaping ([Exercise]) -> Void) {
        let _ = exerciseRef.observe(.value) { snapshot in
            var result: [Exercise] = []
            if snapshot.exists() {
                let rawExercises = snapshot.value as! [String: Any]
                for value in rawExercises.values {
                    guard let rawX = value as? [String: Any],
                          let name = rawX["name"] as? String,
                          let time = rawX["time"] as? Int,
                          let img = rawX["image"] as? String,
                          let rest = rawX["rest"] as? Int else {
                        continue
                    }
                    let x = Exercise()
                    x.name = name
                    x.time = time
                    x.image = img
                    x.rest = rest
                    result.append(x)
                }
            }
            completion(result)
        }
    }
}
