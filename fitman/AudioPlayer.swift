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


/**
    Sound methods
 */
func playCount(elapsed: Double) {
    playCount()
}

func playCount() {
    DispatchQueue.global(qos: .background).async {
        let path = Bundle.main.url(forResource: "select", withExtension: ".wav", subdirectory: "Sounds")
        let sound = NSSound(contentsOf: path!, byReference: true)
        sound!.play()
    }
}
func playEnd(elapsed: Double) {
    playStartOrEnd()
}

func playStart(elapsed: Double) {
    playStartOrEnd()
}

func playStartOrEnd() {
    DispatchQueue.global(qos: .background).async {
        let path = Bundle.main.url(forResource: "tile-turn", withExtension: ".wav", subdirectory: "Sounds")
        let sound = NSSound(contentsOf: path!, byReference: true)
        sound!.play()
    }
}
func playTick(elapsed: Double) {
    playTick()
}

func playTick() {
    DispatchQueue.global(qos: .background).async {
        NSSound(named: "Tink")?.play()
    }
}

func playComplete(elapsed: Double) {
    playComplete()
}

func playComplete() {
    DispatchQueue.global(qos: .background).async {
        let path = Bundle.main.url(forResource: "big-win", withExtension: ".wav", subdirectory: "Sounds")
        let sound = NSSound(contentsOf: path!, byReference: true)
        sound!.play()
    }
}

