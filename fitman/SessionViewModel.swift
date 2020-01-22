import SwiftUI

class SessionViewModel: ObservableObject {
    
    var exercises: ExerciseSession
    
    @Published var currentExerciseIndex: Int
    @Published var isPaused: Bool
    @Published var isStopped: Bool
    @Published var frequency: Double
    @Published var duration: Double
    @Published var elapsed: Double
    @Published var durationBetween: Double
    
    public var progressCallback: ((Double, Double) ->())?
    public var onComplete: (()->())?
    
    private var runner: Runner

    init(exercises: ExerciseSession) {
        self.currentExerciseIndex = 0
        self.exercises = exercises
        self.isPaused = true
        self.isStopped = true
        self.duration = 0.0
        self.elapsed = 0.0
        self.durationBetween = 10.0
        self.frequency = 0.2
        self.runner = Runner()
    }
    
    public func start(){
        print("start")
        self.isPaused = false
        self.isStopped = false
        
        self.playCountIn()
    }
     
    func playCountIn() {
            
        let exercise = self.exercises[self.currentExerciseIndex]
        let cTasks = buildCountInTasks(exercise: exercise)
        
        self.duration = durationBetween
        
        self.runner.start(
            tasks: cTasks,
            frequency: self.frequency,
            duration: Int(durationBetween),
            onProgress: onProgress(elapsed:),
            onComplete: playExercise)
    }
    
    func playExercise() {
        
        let exercise = self.exercises[self.currentExerciseIndex]
        let eTasks = buildExerciseTasks(exercise: exercise)
        
        self.duration = Double(exercise.duration)
        
        self.runner.start(
            tasks: eTasks,
            frequency: self.frequency,
            duration: exercise.duration,
            onProgress: onProgress(elapsed:),
            onComplete: onExerciseDone
        )
    }

    func onExerciseDone() {
        self.next()
    }
    
    public func next(){
        print("next")
        
        // check exists
        self.currentExerciseIndex += 1
        self.start()
    }
    
    public func previous() {
        print("previous")
    }
    
    public func togglePause(){
        print("togglePause")
        
        if (self.isPaused) {
            if (self.isStopped) {
                self.start()
            } else {
                self.resume()
            }
            
        }
        else {
            self.pause()
        }
    }
    
    public func pause(){
        self.isPaused = true
        self.runner.pause()//
        
        pauseAnnouncement()
    }
    
    public func resume(){
        self.isPaused = false
        self.runner.resume()
        
        resumeAnnouncement()
    }

    func onProgress(elapsed: Double) {
//        print("progress at \(elapsed)")
        self.elapsed = elapsed
    }

}
