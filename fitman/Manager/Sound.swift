//
//  Defaults.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/14/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
import SwiftUI


struct Sound {

    static func playCount(elapsed: Double) {
        playCount()
    }

    static func playCount() {
        DispatchQueue.global(qos: .background).async {
            let path = Bundle.main.url(forResource: "select", withExtension: ".wav", subdirectory: "Sounds")
            let sound = NSSound(contentsOf: path!, byReference: true)
            sound!.play()
        }
    }
    static func playEnd(elapsed: Double) {
        playStartOrEnd()
    }

    static func playStart(elapsed: Double) {
        playStartOrEnd()
    }

    static func playStartOrEnd() {
        DispatchQueue.global(qos: .background).async {
            let path = Bundle.main.url(forResource: "tile-turn", withExtension: ".wav", subdirectory: "Sounds")
            let sound = NSSound(contentsOf: path!, byReference: true)
            sound!.play()
        }
    }
    static func playTick(elapsed: Double) {
        playTick()
    }

    static func playTick() {
        DispatchQueue.global(qos: .background).async {
            NSSound(named: "Tink")?.play()
        }
    }

    static func playComplete(elapsed: Double) {
        playComplete()
    }

    static func playComplete() {
        DispatchQueue.global(qos: .background).async {
            let path = Bundle.main.url(forResource: "big-win", withExtension: ".wav", subdirectory: "Sounds")
            let sound = NSSound(contentsOf: path!, byReference: true)
            sound!.play()
        }
    }


}
