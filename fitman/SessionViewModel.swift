import SwiftUI
import AVFoundation
//
// Keeping the paused flag sync'd in the SessionModel and ExerciseRunner is untidy
// need to look at this to figure out how to do it
// https://stackoverflow.com/questions/59036863/add-publisher-behaviour-for-computed-property
//

// The play/pause button should be
//
//  -   displaying "Play" when either an Exercise has not started playing or when an Exercise is Paused
//  -   displaying "Pause" when an Exercise is playing
//
// To capture this have the view model maintain a state variable that has values of the following
// Ennum

enum ViewModelState: String {
    case NotPlaying = "notplaying"
    case Playing = "playing"
    case Paused = "paused"
}
enum PlayPauseLabels: String {
    case Play = "Play"
    case Pause = "Pause"
}

func buttonLabelFromState(state: ViewModelState) -> String {
    var r: String //PlayPauseLabels
    switch (state) {
        case ViewModelState.NotPlaying:
            r = "Play" //PlayPauseLabels.Play
            break
        case ViewModelState.Playing:
            r = "Pause" //PlayPauseLabels.Pause
            break
        case ViewModelState.Paused:
            r = "Play" //PlayPauseLabels.Play
            break
    }
    return r
}

//
// Supervises the playing of the exercises from an ExerciseSession.
//
// Implements the play/next/prev operation for Exercise within an ExerciseSession
// Passes a puase request onto the ExercisePlayer but keeps track of the player pause state
//
// Creates a new instance of an ExercisePlayer for each Exercise in
// an ExerciseSession.
//
// Permits the ExerciseSession to be changed ofter an instance is created.
//
// Also
//
class SessionViewModel: ObservableObject {
    var exercises: ExerciseSession
    var runner: ExercisePlayer?

    @Published var currentExerciseIndex: Int
    @Published var isPaused: Bool
    @Published var isRunning: Bool
    @Published var duration: Double
    @Published var elapsed: Double
    // The label on the play/pause button
    @Published var buttonLabel: String {
        didSet {
            print("buttonLabel: \(self.buttonLabel)")
        }
    }
    var buttonState: ViewModelState {
        didSet {
            self.buttonLabel = buttonLabelFromState(state: self.buttonState)
            print("buttonState: \(self.buttonState)")
        }
    }
    public var progressCallback: ((Double, Double) ->())?
    public var onComplete: (()->())?

    init(exercises: ExerciseSession) {
        // this is because Swift insists that all properties be initialized before
        // I can call any methods. Hence the initialization has to happen twice.
        // Or I make the Controllers Model property @Published
        self.currentExerciseIndex = 0
        self.exercises = exercises
        self.isPaused = true
        self.isRunning = false
        self.buttonState = ViewModelState.NotPlaying
        self.buttonLabel = buttonLabelFromState(state: self.buttonState)
        self.duration = 100.0
        self.elapsed = 0.0
    }
    func changeSession(exercises: ExerciseSession) {
        print("SessionModel::changeSession")
        self.currentExerciseIndex = 0
        self.exercises = exercises
        self.isPaused = true
        self.isRunning = false
        self.buttonState = ViewModelState.NotPlaying
        self.buttonLabel = buttonLabelFromState(state: self.buttonState)
        self.duration = 100.0
        self.elapsed = 0.0
        if let r = self.runner {
            r.stop()
            self.runner = nil
        }
    }
    
    func play(){
        self.go()
    }
    
    // Start playing the exercise session
    func go() {
        self.runner = ExercisePlayer(exercise: exercises[self.currentExerciseIndex])
        self.runner!.onComplete = {
            print("runner complete")
            self.buttonState = ViewModelState.NotPlaying
            self.next()
        }
        self.runner!.onProgressReport = { (a: Double, b: Double) in
            print("progress report \(a) \(b)")
            self.duration = b
            self.elapsed = a
        }
        self.runner!.go()
        self.buttonState = ViewModelState.Playing
        self.isPaused = self.runner!.pauseFlag

    }
    // Move to the next exercise in the session. 
    func next() {
        if let r = self.runner {
            r.stop()
            self.runner = nil
            self.buttonState = ViewModelState.NotPlaying
        }
        self.elapsed = 0.0; self.duration = 100.0
        if(self.currentExerciseIndex < self.exercises.count - 1) {
            self.currentExerciseIndex += 1
            self.go()
        } else {
            print("all exercises complete")
            self.buttonState = ViewModelState.NotPlaying
            if let cb = self.onComplete {
                cb()
            }
        }
    }
    
    func previous() {
        if let r = self.runner {
            r.stop()
            self.runner = nil
            self.buttonState = ViewModelState.NotPlaying
        }
        self.elapsed = 0.0; self.duration = 100.0
        self.currentExerciseIndex = (self.currentExerciseIndex + self.exercises.count - 1) % self.exercises.count
        self.go()
    }
    func togglePause() {
        if let r = self.runner {
            if (!r.runningFlag) {
                self.go()
            } else {
            
            }
            r.togglePause()
            self.isPaused = r.pauseFlag
            self.buttonState = (self.isPaused) ? ViewModelState.Paused : ViewModelState.Playing
        } else {
            self.go()
        }
    }
}
