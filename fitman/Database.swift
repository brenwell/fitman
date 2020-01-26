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
struct Exercise: Identifiable, Decodable, Encodable {
        private enum CodingKeys : String, CodingKey {
            case label = "label"
            case duration = "duration"
            
        }
    var label: String
    var duration: Int
    var id: Int?
}

typealias Exercises = Array<Exercise>
typealias Routines = Array<Routine>

struct Routine: Identifiable, Decodable, Encodable {
        private enum CodingKeys : String, CodingKey {
            case label = "label"
            case gap = "gap"
            case exercises = "exercises"
            
        }
    var label: String
    var gap: Int
    var exercises: Exercises
    var id: Int?
}

struct Database: Decodable, Encodable {
    private enum CodingKeys : String, CodingKey {
        case routines = "routines"
        case modified = "modified"
    }
    var routines: Routines
    var modified: String
}
