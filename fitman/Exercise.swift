//
//  Exercise.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/9/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation

// An exercise session consists of a list of exercise descriptions and
// a time drutaion for which each exercise should be performed
struct Exercise: Identifiable, Decodable {
        private enum CodingKeys : String, CodingKey {
            case label = "label"
            case duration = "duration"
            
        }
    var label: String
    var duration: Int
    var id: Int?
}

// An exercise session is a list of exercises
typealias ExerciseSession = Array<Exercise>

// This type holds a database of named ExerciseSession (exercise sessions)
typealias ExerciseSessionDatabase = [String: ExerciseSession]
