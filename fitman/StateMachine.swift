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

let TICKS_PER_SEC = 60

func doubleTicksPerSecond() -> Double {
    return Double(TICKS_PER_SEC)
}

func intTicksPerSeconds() -> Int {
    return TICKS_PER_SEC
}

func onTheSecond(ticks: Int) -> Bool {
    return ticks % TICKS_PER_SEC == 0
}

func ticksToSeconds(ticks: Int) -> Int {
    return ticks / TICKS_PER_SEC
}

func secondsToTicks(secs: Int) -> Int {
    return TICKS_PER_SEC * secs
}

enum SM_State {
    case announcement
    case idle // while waiting for the announcement to complete
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
    var preludeCount = secondsToTicks(secs: 10)
    
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    func start(exercise: Exercise) {
        self.exercise = exercise
        self.exerciseCounter = secondsToTicks(secs: exercise.duration)
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
            if ((self.counter < secondsToTicks(secs: 4)) && (self.counter > 0) && (onTheSecond(ticks: self.counter))) {
                self.playPopSound()
            } else if (self.counter == 0) {
                self.playPurrSound()
            }
            if (self.counter <= 0) {
                self.state = SM_State.exercise
                self.counter = 0
                self.exerciseCounter = secondsToTicks(secs: self.exercise.duration)
            }
        case .exercise:
            print("state: exercise \(self.exerciseCounter)")
            self.exerciseCounter -= 1
            self.counter += 1
            if (self.counter % secondsToTicks(secs:10) == 0) {
                if (self.exerciseCounter > secondsToTicks(secs:9)) {
                    if (onTheSecond(ticks: self.counter)) {
                        self.say(String( ticksToSeconds(ticks: self.counter) ))
                    }
                }
            }
            if (self.exerciseCounter < secondsToTicks(secs:3)) {
                if (onTheSecond(ticks: self.exerciseCounter)){
                    self.playTinkSound()
                }
            }
            if (self.exerciseCounter <= 0) {
//                self.state = SM_State.done
                self.state = SM_State.postlude
                self.counter = self.preludeCount
                self.counter = secondsToTicks(secs:1)
            }
        case .progressAnnounement:
            print("state: progressAnnouncement")
        case .postlude:
            print("state: postlude")
            self.counter -= 1
            if(self.counter == 0) {
                self.playPurrSound()
            }
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
