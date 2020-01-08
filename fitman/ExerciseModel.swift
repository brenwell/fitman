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


class ExerciseModel {
    var nbrExercises: Int
    var currentExerciseIndex: Int
    var pausedFlag: Bool
    var exercises: Array<Exercise>
    var stateMachine: StateMachine?
    var timer: Timer?
    
    init (exercises: Array<Exercise>) {
        self.exercises = exercises
        self.nbrExercises = exercises.count
        self.pausedFlag = false
        self.currentExerciseIndex = 0
    }

    func previous() {
        self.currentExerciseIndex = (self.currentExerciseIndex - 1 + self.nbrExercises) % self.nbrExercises
        self.go()
    }
    
    func next() {
        self.currentExerciseIndex = (self.currentExerciseIndex + 1) % self.nbrExercises
        self.go()
    }
    
    func togglePause() {
        self.pausedFlag = !self.pausedFlag
    }
    
    func go() {
        let ex: Exercise = self.exercises[self.currentExerciseIndex]
        self.stateMachine = StateMachine(exercise: ex)
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)

    }
    
    @objc func handleTimer() throws {
        // pause simple stops the state machine ticking
        if (!self.pausedFlag) {
            if (SM_State.done == self.stateMachine?.tick()) {
                if (self.currentExerciseIndex + 1 < self.nbrExercises) {
                    self.next()
                } else {
                    print("we are done")
                    self.next()
                }
            }
        }
    }
}

