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


enum SM_State {
    case idle
    case announcement
    case prelude
    case exercise
    case progressAnnounement
    case postlude
    case done
}

class StateMachine: Speaker {
    var state: SM_State = SM_State.announcement
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
    
    func tick() -> SM_State {
        switch self.state {
        case .idle:
            print("idle state")
        case .announcement:
            print("state: announcement")
            self.announce(self.exercise)
            self.state = SM_State.idle
        case .prelude:
            print("state: prelude")
            self.counter -= 1;
            self.playPopSound()
            if (self.counter <= 0) {
                self.state = SM_State.exercise
                self.counter = 0
                self.exerciseCounter = self.exercise.duration
            }
        case .exercise:
            print("state: exercise \(self.exerciseCounter)")
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
            print("state: progressAnnouncement")
        case .postlude:
            print("state: postlude")
            self.counter -= 1;
            self.playPopSound()
            if (self.counter <= 0) {
                self.state = SM_State.done
                self.counter = 0
                self.exerciseCounter = self.exercise.duration
            }
        case .done:
            break
        }
        return self.state
    }
    
    override func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speaking all done")
        if (self.state == SM_State.idle) {
            self.state = SM_State.prelude
            self.counter = self.preludeCount
        }
    }   
}