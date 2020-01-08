//
//  AppDelegate.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/7/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Cocoa
import SwiftUI
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
        var avSpeechSynthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
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

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("speaking all done")
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

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {}
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) { }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) { }
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var timer: Timer?
    var timer_counter: Int32 = 0
    var speaker: Speaker = Speaker()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        self.startTimer()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func startTimer() {
        self.timer?.invalidate()
        self.timer_counter = 0
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    
    }
    
    @objc func handleTimer() {
        print("handleTimer")
//        if (self.timer_counter % 10 == 0) {
//            self.speaker.announce(y[0])
//        }
        if (self.timer_counter % 10 == 0) {
//            self.speaker.playPurrSound();
        }
        if (self.timer_counter % 5 == 0) {
            self.speaker.playPopSound();
        }
        if (self.timer_counter % 5 == 0) {
//            self.speaker.playTinkSound();
        }
        self.timer_counter += 1
        print(String(format:"Timer interval expired counter: %d", self.timer_counter))
    }

}

