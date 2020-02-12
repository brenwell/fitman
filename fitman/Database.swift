//
//  Exercise.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/9/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation

/** On disk data **/

struct PersistedExercise: Codable {
        private enum CodingKeys : String, CodingKey {
            case label = "label"
            case duration = "duration"
            case enabled = "enabled"
        }
    var label: String
    var duration: Int
    var enabled: Bool
    
}

typealias PersistedExercises = Array<PersistedExercise>
typealias PersistedRoutines = Array<PersistedRoutine>

struct PersistedRoutine: Codable {
        private enum CodingKeys : String, CodingKey {
            case label = "label"
            case gap = "gap"
            case exercises = "exercises"
            
        }
    var label: String
    var gap: Int
    var exercises: PersistedExercises
}

struct PersistedDatabase: Codable {
    private enum CodingKeys : String, CodingKey {
        case routines = "routines"
        case modified = "modified"
        case current = "current"
    }
    var routines: PersistedRoutines
    var modified: String
    var current: Int
}



/** In memory data **/

struct Exercise: Identifiable {
    var id: UUID = UUID()
    var label: String
    var duration: Int
    var enabled: Bool
}

typealias Exercises = Array<Exercise>
typealias Routines = Array<Routine>

struct Routine: Identifiable {
    var id: UUID = UUID()
    var label: String
    var gap: Int
    var exercises: Exercises
    var totalDuration: String?
}

struct Database {
    var routines: Routines
    var modified: String
    var current: Int
}
