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


class Speaker: NSObject, AVSpeechSynthesizerDelegate {
    var avSpeechSynthesizer: AVSpeechSynthesizer
    var noSound: Bool
    override init() {
        self.avSpeechSynthesizer = AVSpeechSynthesizer()
        self.noSound = true
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
        self.avSpeechSynthesizer = AVSpeechSynthesizer()
        self.avSpeechSynthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: exercise.label + " for \(exercise.duration) seconds")
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.daniel.premium")
//        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.Zarvox")
        if (self.noSound) {
            print("Speaker::announce \(exercise.label) \(exercise.duration)")
            DispatchQueue.main.async {[weak self, avSpeechSynthesizer, utterance] in
              self.speechSynthesizer(avSpeechSynthesizer, didFinish: utterance )
            }
            return
        }
        self.avSpeechSynthesizer.speak(utterance)
    }
    func say(_ text: String) {
        self.avSpeechSynthesizer = AVSpeechSynthesizer()
        self.avSpeechSynthesizer.delegate = self
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.daniel.premium")
        if (self.noSound) {
            print("Speaker::announce \(text)")
            self.speechSynthesizer(avSpeechSynthesizer, didFinish: utterance )
            return
        }
        self.avSpeechSynthesizer.speak(utterance)
    }

    func playTinkSound() {
        if self.noSound {
            print("Speaker::playTinkSound")
            return
        }
        NSSound(named: "Tink")?.play()
    }
    func playPurrSound() {
        if self.noSound {
            print("Speaker::playPurrSound")
            return
        }
        NSSound(named: "Purr")?.play()
    }
    func playPopSound() {
        if self.noSound {
            print("Speaker::playPopSound")
            return
        }
        NSSound(named: "Pop")?.play()
    }
    func announceCallback() {
        print("annouceCallback")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
        self.announceCallback()
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) { }
}
