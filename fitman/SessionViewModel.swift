import SwiftUI

enum SessionState {
    case stopped
    case countingIn
    case playing
    case paused
}

class SessionViewModel: ObservableObject {
    
    var exercises: ExerciseSession
    
    @Published var currentExerciseIndex: Int
    @Published var state: SessionState
    @Published var frequency: Double
    @Published var duration: Double
    @Published var elapsed: Double
    @Published var durationBetween: Double
    
    private var runner: Runner
    private var prevState: SessionState

    init(exercises: ExerciseSession) {
        self.currentExerciseIndex = 0
        self.exercises = exercises
        self.state = .stopped
        self.prevState = .stopped
        self.duration = 0.0
        self.elapsed = 0.0
        self.durationBetween = 6.0
        self.frequency = 0.1
        self.runner = Runner()
    }
    
    public func start(){
        print("start")
        self.playCountIn()
    }
     
    func playCountIn() {
        
        self.state = .countingIn
        
        let exercise = self.exercises[safe: self.currentExerciseIndex]
        
        if ((exercise) == nil) {
            print("done")
            speaker.say("Done")
            return
        }
        
        let tasks = buildCountInTasks(exercise: exercise!, duration: durationBetween)
        
        self.runner.start(
            tasks: tasks,
            frequency: self.frequency,
            duration: Int(durationBetween),
            onProgress: onProgress,
            onComplete: playExercise)
    }
    
    func playExercise() {
        
        self.state = .playing
        
        let exercise = self.exercises[self.currentExerciseIndex]
        let tasks = buildExerciseTasks(exercise: exercise)
        
        self.runner.start(
            tasks: tasks,
            frequency: self.frequency,
            duration: exercise.duration,
            onProgress: onProgress,
            onComplete: onExerciseDone
        )
    }

    func onExerciseDone() {
        self.next()
    }
    
    public func next(){
        
        if (self.exercises.count <= self.currentExerciseIndex + 1) {
            self.state = .stopped
            print("done")
            return
        }
        
        print("next")
        
        self.currentExerciseIndex += 1
        self.start()
    }
    
    public func previous() {
        print("previous")
        
        if (self.currentExerciseIndex - 1 <= 0) {
//            self.state = .stopped
            print("at beginning")
            return
        }
        
        print("prev")
        
        self.currentExerciseIndex -= 1
        self.start()
    }
    
    public func togglePause(){
        print("togglePause")
        
        switch self.state {
        case .stopped:
            return self.start()
        case .paused:
            return self.resume()
        default:
            self.pause()
        }
    }
    
    public func pause(){
        self.prevState = self.state
        self.state = .paused
        self.runner.pause()//
        
        pauseAnnouncement()
    }
    
    public func resume(){
        self.state = self.prevState
        self.runner.resume()
        
        resumeAnnouncement()
    }
    
    public func stop(){
        self.state = .stopped
        self.runner.stop()
    }

    func onProgress(elapsed: Double, duration: Double) {
//        print("progress at \(elapsed)")
        self.elapsed = elapsed
        self.duration = duration
    }

}
