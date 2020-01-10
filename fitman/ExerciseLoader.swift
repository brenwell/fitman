//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
import Cocoa
import SwiftUI
import Foundation
import AVFoundation

//var yy : Array<Exercise> = [
//    Exercise(label:"Push Ups, set of 5", duration: 40),
//    Exercise(label:"Door stretch", duration: 30),
//    Exercise(label:"FReverse plank", duration: 50),
//    Exercise(label:"Wall stand", duration: 60),
//]


func loadExercises(path: String) -> Array<Exercise> {
    let yyy: Array<Exercise> = loadExerciseFile()["rob"]!
    return yyy
}
func loadExerciseFile() -> SessionDatabase {
    if let filepath = Bundle.main.path(forResource: "exercise", ofType: "json") {
        do {
            let contents = try String(contentsOfFile: filepath)
//            print(contents)
            let data = Data(contents.utf8)
            let decoder = JSONDecoder()
            do {
                let exDb = try decoder.decode([String: [Exercise]].self, from: data)
                let ex: [Exercise] = exDb["rob"]!
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
