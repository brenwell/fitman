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
        if !self.isPaused {
            
            flagAsPauseOrStop()
        } else {
            flagAsResumeOrStart()
        }
    }
    
    func flagAsPauseOrStop() {
        enableScreenSleep()
        self.isRunning = false
        self.isPaused = true
    }
    
    func flagAsResumeOrStart() {
        
        disableScreenSleep()
        self.isRunning = true
        self.isPaused = false
    }
    
    func go() {
        let ex: Exercise = self.exercises[self.currentExerciseIndex]
        self.contentView?.state = self
        self.contentView?.current = self.currentExerciseIndex
        self.stateMachine = StateMachine(exercise: ex)
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
        flagAsResumeOrStart()
    }
    
    @objc func handleTimer() {
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
            } else if ((self.stateMachine!.state == SM_State.prelude)
                    /*|| (self.stateMachine!.state == SM_State.postlude)*/) {
                self.duration = Double(self.stateMachine!.preludeCount)
                self.elapsed = self.duration - Double(self.stateMachine!.counter)
            } else {
                self.duration = 0.0
                self.elapsed = 100.0
            }
            print("elapsed: \(self.elapsed)")
            print("duration: \(self.duration)")
        }
    }
}
  
class FancyTimer {

    var timer: Timer?
    var timestamp: TimeInterval
    var handler: ((Double) -> Void)
    
    init(handler: @escaping (Double) -> Void) {
        self.handler = handler
        self.timestamp = 0.0
        self.getFrame()
    }

    func getFrame() {
        
        self.timestamp = NSDate().timeIntervalSince1970
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.1,
            target: self,
            selector: #selector(gotFrame),
            userInfo: nil,
            repeats: true
        )
    }
    func invalidate() {
        self.timer!.invalidate()
        self.timestamp = 0.0
    }
    
    @objc func gotFrame() {
        
        let nextTimestamp = NSDate().timeIntervalSince1970
        if (self.timestamp == 0.0) {
            print("timestamp was zero")
            return
        }
        let delta: Double = nextTimestamp - self.timestamp
        self.timestamp = nextTimestamp
        
        handler(delta)
    }

}
