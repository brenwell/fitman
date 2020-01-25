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
    
    var synthesizer: AVSpeechSynthesizer?
    
    override init() {
        
        super.init()
        
//        AVAudioSession.sha
//        let speechVoices = AVSpeechSynthesisVoice.speechVoices()
//        speechVoices.forEach { (voice) in
//          print("**********************************")
//          print("Voice identifier: \(voice.identifier)")
//          print("Voice language: \(voice.language)")
//          print("Voice name: \(voice.name)")
//          print("Voice quality: \(voice.quality.rawValue)") // Compact: 1 ; Enhanced: 2
//        }
    }
    
    func say(_ text: String) {
        
        self.stopSpeech()
        
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer!.delegate = self
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.4
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
//        utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.daniel.premium")
        DispatchQueue.global(qos: .background).async {
            // Bren this worked to smooth out the progress display
            self.synthesizer!.speak(utterance)
        }
    }

    func stopSpeech(){
        if ((self.synthesizer) != nil) {
            self.synthesizer!.stopSpeaking(at: .immediate)
        }
    }
    
    func pauseSpeech() {
        if ((self.synthesizer) != nil) {
            self.synthesizer!.pauseSpeaking(at: .immediate)
        }
    }
    
    func resumeSpeech() {
        if ((self.synthesizer) != nil) {
            self.synthesizer!.continueSpeaking()
        }
    }
    
    func playTinkSound() {
        DispatchQueue.global(qos: .background).async {
            NSSound(named: "Tink")?.play()
        }
    }
    func playPurrSound() {
        DispatchQueue.global(qos: .background).async {
            NSSound(named: "Purr")?.play()
        }
    }
    func playPopSound() {
        DispatchQueue.global(qos: .background).async {
            NSSound(named: "Pop")?.play()
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish", self.synthesizer)
//        self.synthesizer = nil
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("didCancel")
        self.synthesizer = nil
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) { }
}
