import SwiftUI

enum RoutineState {
    case stopped
    case countingIn
    case playing
    case paused
}

class RoutineModel: ObservableObject {
    
    var routine: Routine
    var enabledExercises: Exercises
    
    @Published var currentExerciseIndex: Int
    @Published var state: RoutineState
    @Published var frequency: Double
    @Published var duration: Double
    @Published var elapsed: Double
    @Published var durationBetween: Double
    @Published var totalDuration: String = "n/a"
    
    private var speaker: Speaker
    private var runner: TaskRunner
    private var prevState: RoutineState

    init(routine: Routine, speaker: Speaker) {
        self.currentExerciseIndex = 0
        self.routine = routine
        self.state = .stopped
        self.prevState = .stopped
        self.durationBetween = Double(routine.gap)
        self.frequency = Settings.frequency
        self.runner = TaskRunner()
        self.speaker = speaker
        
        // Used to publish progress
        self.duration = 0.0
        self.elapsed = 0.0
        
        self.enabledExercises = routine.exercises.filter { $0.enabled }
        self.totalDuration = calculateTotalDuration(exercises: self.enabledExercises)
    }
    
    public func start(){
        print("start")
        self.playCountIn()
        
        disableScreenSleep()
    }
     
    func playCountIn() {
        
        self.state = .countingIn
        
        guard let exercise = self.enabledExercises[safe: self.currentExerciseIndex] else {
            self.stop(playNoise: false)
            return
        }
        
        let tasks = buildCountInTasks(exercise: exercise, duration: durationBetween)
        
        self.runner.start(
            tasks: tasks,
            frequency: self.frequency,
            duration: Int(durationBetween),
            onProgress: onProgress,
            onComplete: playExercise)
    }
    
    func playExercise() {
        
        self.state = .playing
        
        let exercise = self.enabledExercises[self.currentExerciseIndex]
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
        
        if (self.enabledExercises.count <= self.currentExerciseIndex + 1) {
            self.stop(playNoise: true)
            
            self.currentExerciseIndex = 0
            return
        }
        
        print("next")
        
        self.currentExerciseIndex += 1
        
        if (self.state == .playing || self.state == .countingIn) {

            self.start()
        }
    }
    
    public func previous() {
        print("previous")
        
        if (self.currentExerciseIndex - 1 < 0) {
            print("at beginning")
            return
        }
        
        print("prev")
        
        self.currentExerciseIndex -= 1
        
        if (self.state == .playing || self.state == .countingIn) {

            self.start()
        }
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
        
        self.speaker.pauseSpeech()
        
        enableScreenSleep()
    }
    
    public func resume(){
        self.state = self.prevState
        self.runner.resume()
        
        self.speaker.resumeSpeech()
        
        disableScreenSleep()
    }
    
    public func stop(playNoise: Bool){
        print("done")
        self.state = .stopped
        self.runner.stop()
        
        enableScreenSleep()
        
        if playNoise {
            Sound.playComplete(elapsed: 0.0)
        }
    }

    func onProgress(elapsed: Double, duration: Double) {

        self.elapsed = elapsed
        self.duration = duration
    }
    
    func buildCountInTasks(exercise: Exercise, duration: Double) -> Array<Task> {
        
        var tasks = [Task]()
        
        tasks.append(Task(elapsed: 0.0, action: playExceriseAnnoucement(text: exercise.label, duration: exercise.duration)))
        tasks.append(Task(elapsed: duration - 3.0, action: Sound.playCount(elapsed:)))
        tasks.append(Task(elapsed: duration - 2.0, action: Sound.playCount(elapsed:)))
        tasks.append(Task(elapsed: duration - 1.0, action: Sound.playStart(elapsed:)))
        
        return tasks
    }

    func buildExerciseTasks(exercise: Exercise) -> Array<Task> {
        
        var tasks = [Task]()
        
        let duration: Double = Double(exercise.duration)
        let interval = Settings.announceInterval
        
        if (interval > 0) {
            for i in stride(from: interval, to: Int(duration), by: interval) {
                let txt: String = "\(Int(duration) - Int(i))"
                tasks.append(Task(elapsed: Double(i), action: playProgressAnnoucement(text: txt)))
            }
        }

        tasks.append(Task(elapsed: duration - 3.0, action: Sound.playCount(elapsed:)))
        tasks.append(Task(elapsed: duration - 2.0, action: Sound.playCount(elapsed:)))
        tasks.append(Task(elapsed: duration - 1.0, action: Sound.playEnd(elapsed:)))
        

        // sort tasks - should be unnecessary
    //    tasks = tasks.sorted(by: { $0.elapsed < $1.elapsed })
        
        return tasks
    }
    
    func playProgressAnnoucement(text: String)-> ((Double)->Void) {
        return { (elapsed: Double) -> Void in
            self.speaker.say(text)
        }
    }

    func playExceriseAnnoucement(text: String, duration: Int)-> ((Double)->Void) {
        let str = "\(text) for \(duration) seconds"
        return { (elapsed: Double) -> Void in
            self.speaker.say(str)
        }
    }

}


func calculateTotalDuration(exercises: Exercises) -> String{
    
    let sum = exercises.reduce(0) {
        if (!$1.enabled) { return $0 }
        return $0 + $1.duration
    }
    
    print(sum)
    

    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .full

    let formattedString = formatter.string(from: TimeInterval(sum))!
    print(formattedString)
    
    return formattedString
}