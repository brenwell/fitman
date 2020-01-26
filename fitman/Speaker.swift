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
    var voice: String?
    var locale: String?
    var rate: Float?
    
    
    init(voice: String, locale: String, rate: Float) {
        self.rate = rate
        self.voice = voice
        self.locale = locale
    }
    
    func say(_ text: String) {
        
        self.stopSpeech()
        
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer!.delegate = self
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = self.rate!
        utterance.voice = AVSpeechSynthesisVoice(language: self.locale)
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
        
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish", self.synthesizer!)
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
    
    func printVoices() {
//                AVAudioSession.sha
        let speechVoices = AVSpeechSynthesisVoice.speechVoices()
        speechVoices.forEach { (voice) in
          print("**********************************")
          print("Voice identifier: \(voice.identifier)")
          print("Voice language: \(voice.language)")
          print("Voice name: \(voice.name)")
          print("Voice quality: \(voice.quality.rawValue)") // Compact: 1 ; Enhanced: 2
        }
    }
}
