//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Foundation
import AVFoundation

enum SM_State {
    case idle
    case announcement
    case prelude
    case exercise
    case progressAnnounement
    case postlude
}

struct FitmanError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

class Controller {
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
            do {
                try self.stateMachine?.tick()
            } catch {
                print("got an error") // do something more usefull
            }
        }
    }
}

class StateMachine: Speaker {
    var state: SM_State = SM_State.idle
    var exercise: Exercise
    var counter: Int = 0
    var exerciseCounter: Int = 0
    var preludeCount = 10
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    func start(exercise: Exercise) {
        self.exercise = exercise
        self.exerciseCounter = exercise.duration
    }
    
    func idle() {
    
    }
    
    func tick() throws {
        switch self.state {
        case .idle:
            print("here")
        case .announcement:
            self.announce(self.exercise)
        case .prelude:
            self.counter -= 1;
            self.playPopSound()
            if (self.counter <= 0) {
                self.state = SM_State.exercise
                self.counter = 0
                self.exerciseCounter = self.exercise.duration
            }
        case .exercise:
            self.exerciseCounter -= 1
            self.counter += 1
            if (self.counter % 10 == 0) {
                self.say(String(self.counter))
            }
            if (self.exerciseCounter <= 0) {
                self.state = SM_State.postlude
                self.counter = self.preludeCount
            }
        case .progressAnnounement:
            print("here")
        case .postlude:
            self.counter -= 1;
            self.playPopSound()
            if (self.counter <= 0) {
                self.state = SM_State.idle
                self.counter = 0
                self.exerciseCounter = self.exercise.duration
            }
        }
    
    }
    
    override func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speaking all done")
        self.state = SM_State.prelude
        self.counter = self.preludeCount
    }

    
}
