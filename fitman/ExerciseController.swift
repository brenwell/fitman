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

//var x : Exercise = Exercise(label:"This is a label", duration: 32)
//var y : Array<Exercise> = [
//    Exercise(label:"Push Ups, set of 5", duration: 40),
//    Exercise(label:"Door stretch", duration: 30),
//    Exercise(label:"FReverse plank", duration: 50),
//    Exercise(label:"Wall stand", duration: 60),
//]

class ExerciseController {
    var model: ExerciseModel
    init() {
        let ex: Array<Exercise> = loadExercises(path: "")
        self.model = ExerciseModel(exercises: ex)
//        self.model.go()
    }
}

