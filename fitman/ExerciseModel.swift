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

struct Exercise: Identifiable, Decodable {
        private enum CodingKeys : String, CodingKey {
            case label = "label"
            case duration = "duration"
            
        }
    var label: String
    var duration: Int
    var id: Int?
}


class ExerciseModel: ObservableObject {
    var nbrExercises: Int
    @Published var currentExerciseIndex: Int
    @Published var isPaused: Bool
    @Published var isRunning: Bool
    @Published var duration: Double
    @Published var elapsed: Double

    var exercises: Array<Exercise>
    var stateMachine: StateMachine?
    var timer: Timer?
    var contentView: ContentView?
    
    init (exercises: Array<Exercise>) {
        self.exercises = exercises
        self.nbrExercises = exercises.count
        self.isPaused = false
        self.isRunning = false
        self.currentExerciseIndex = 0
        self.duration = 0.0
        self.elapsed = 0.0
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
        if !self.isRunning {
            self.go()
            return
        }
        self.isPaused = !self.isPaused
    }
    
    func go() {
        let ex: Exercise = self.exercises[self.currentExerciseIndex]
        self.contentView?.state = self
        self.contentView?.current = self.currentExerciseIndex
        self.stateMachine = StateMachine(exercise: ex)
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
        self.isRunning = true
        self.isPaused = false
    }
    
    @objc func handleTimer() throws {
        // pause simple stops the state machine ticking
        if (!self.isPaused) {
            if (SM_State.done == self.stateMachine?.tick()) {
                if (self.currentExerciseIndex + 1 < self.nbrExercises) {
                    self.next()
                } else {
                    print("we are done")
                    self.next()
                }
            }
            if(self.stateMachine!.state == SM_State.exercise) {
                self.duration = Double(self.exercises[self.currentExerciseIndex].duration)
                self.elapsed = self.duration - Double(self.stateMachine!.exerciseCounter)
            } else {
                self.duration = 0.0
                self.elapsed = 0.0
            }
            print("elapsed: \(self.elapsed)")
            print("duration: \(self.duration)")
        }
    }
}

