import SwiftUI
import AVFoundation

/**
  Speech methods
 */
let speaker: Speaker = Speaker(
    voice: "com.apple.speech.synthesis.voice.daniel.premium",
    locale: "en-GB"
)

func playProgressAnnoucement(text: String)-> ((Double)->Void) {
    return { (elapsed: Double) -> Void in
        speaker.say(text)
    }
}

func playExceriseAnnoucement(text: String, duration: Int)-> ((Double)->Void) {
    let str = "\(text) for \(duration) seconds"
    return { (elapsed: Double) -> Void in
        speaker.say(str)
    }
}

func pauseAnnouncement(){
    speaker.pauseSpeech()
}

func resumeAnnouncement(){
    speaker.resumeSpeech()
}


