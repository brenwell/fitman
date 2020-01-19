//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
// Functions for loading a simple database of exercise sessions
//
//
import Cocoa
import SwiftUI
import Foundation
import AVFoundation


func loadExercises(path: String) -> ExerciseSession {
    let yyy: ExerciseSession = loadExerciseFile()["rob"]!
    return yyy
}
func loadExerciseFile() -> ExerciseSessionDatabase {
    if let filepath = Bundle.main.path(forResource: "exercise", ofType: "json") {
        do {
            let contents = try String(contentsOfFile: filepath)
//            print(contents)
            let data = Data(contents.utf8)
            let decoder = JSONDecoder()
            do {
                let exDb = try decoder.decode(ExerciseSessionDatabase.self, from: data)
//                let ex: ExerciseSession = exDb["rob"]!
                return exDb
            } catch {
                exerciseErrorDialog(text: "JSON decode of exercise.json failed")
            }
            
        } catch {
            exerciseErrorDialog(text: "JSON read of file exercise.json failed")
        }
    } else {
        exerciseErrorDialog(text: "JSON file exercise.json not found")
    }
    return ["rob":[]]
}
