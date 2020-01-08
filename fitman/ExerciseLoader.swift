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
    let yyy: Array<Exercise> = loadExerciseFile()
    return yyy
}
func loadExerciseFile() -> Array<Exercise> {
    if let filepath = Bundle.main.path(forResource: "exercise", ofType: "json") {
        do {
            let contents = try String(contentsOfFile: filepath)
            print(contents)
            let data = Data(contents.utf8)
            let decoder = JSONDecoder()
            do {
                let ex = try decoder.decode([Exercise].self, from: data)
                print(ex)
                return ex
            } catch {
                print(error)
                exerciseErrorDialog(text: "JSON decode of exercise.json failed")
            }
            
        } catch {
            exerciseErrorDialog(text: "JSON read of file exercise.json failed")
        }
    } else {
        print("file not found")
        exerciseErrorDialog(text: "JSON file exercise.json not found")
    }
    return []
}
