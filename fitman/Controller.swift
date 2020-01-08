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

struct Exercise {
    var label: String,
    duration: Int
}

var x : Exercise = Exercise(label:"This is a label", duration: 32)
var y : Array<Exercise> = [
    Exercise(label:"Push Ups, set of 5,  30 seconds", duration: 10),
    Exercise(label:"This is a label", duration: 32),
    Exercise(label:"This is a label", duration: 32),
    Exercise(label:"This is a label", duration: 32),
]


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

class ExerciseController {
    var model: ExerciseModel
    init() {
        self.model = ExerciseModel(exercises: y)
        self.model.go()
    }
}

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
            do {
                try self.stateMachine?.tick()
            } catch {
                print("got an error") // do something more usefull
            }
        }
    }
}
class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    override init() {
        super.init()
//        let speechVoices = AVSpeechSynthesisVoice.speechVoices()
//        speechVoices.forEach { (voice) in
//          print("**********************************")
//          print("Voice identifier: \(voice.identifier)")
//          print("Voice language: \(voice.language)")
//          print("Voice name: \(voice.name)")
//          print("Voice quality: \(voice.quality.rawValue)") // Compact: 1 ; Enhanced: 2
//        }
    }
    func announce(_ exercise: Exercise) {
        let avSpeechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        avSpeechSynthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: exercise.label)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.daniel.premium")
        avSpeechSynthesizer.speak(utterance)
    }
    func say(_ text: String) {
        let avSpeechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        avSpeechSynthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.daniel.premium")
        avSpeechSynthesizer.speak(utterance)
    }

    func playTinkSound() {
        NSSound(named: "Tink")?.play()
    }
    func playPurrSound() {
        NSSound(named: "Purr")?.play()
    }
    func playPopSound() {
        NSSound(named: "Pop")?.play()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("didStart")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) { }
}


class StateMachine {
    var state: SM_State = SM_State.announcement
    var exercise: Exercise
    var counter: Int = 0
    var exerciseCounter: Int = 0
    var preludeCount = 10
    var speaker: Speaker
    
    init(exercise: Exercise) {
    self.speaker = Speaker()
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
            let speaker: Speaker = Speaker()
            speaker.announce(self.exercise)
            self.state = SM_State.idle
        case .prelude:
            self.counter -= 1;
            self.speaker.playPopSound()
            if (self.counter <= 0) {
                self.state = SM_State.exercise
                self.counter = 0
                self.exerciseCounter = self.exercise.duration
            }
        case .exercise:
            self.exerciseCounter -= 1
            self.counter += 1
            if (self.counter % 10 == 0) {
                self.speaker.say(String(self.counter))
            }
            if (self.exerciseCounter <= 0) {
                self.state = SM_State.postlude
                self.counter = self.preludeCount
            }
        case .progressAnnounement:
            print("here")
        case .postlude:
            self.counter -= 1;
            self.speaker.playPopSound()
            if (self.counter <= 0) {
                self.state = SM_State.idle
                self.counter = 0
                self.exerciseCounter = self.exercise.duration
            }
        }
    
    }
    
//    override func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
//        print("speaking all done")
//        self.state = SM_State.prelude
//        self.counter = self.preludeCount
//    }

    
}
