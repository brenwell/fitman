import SwiftUI
import AVFoundation

let speaker: Speaker = Speaker()

func playPop(elapsed: Double) {
    speaker.playPopSound()
}
func playTink(elapsed: Double) {
    speaker.playTinkSound()
}
func playPurr(elapsed: Double) {
    speaker.playPurrSound()
}

func playEnd(elapsed: Double) {
    speaker.playPurrSound()
}

func playEndSound(elapsed: Double) {
    speaker.playPurrSound()
}

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

