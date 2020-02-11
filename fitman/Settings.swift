import SwiftUI

/**
  Speech methods
 */
struct Settings {
    let voice: String = "com.apple.speech.synthesis.voice.daniel.premium"
    let locale: String = "en-GB"
    let rate: Float = 0.4 // playback rate
    let frequency: Double = 0.1
    let gap: Double = 6.0
    let announceInterval: Int = 10 // how often to announce
}


