import SwiftUI
import AVFoundation

//let speaker: Speaker = Speaker()
func playStart(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.say("This is a long announcement describing an exercise toes and no toes")
    print("play start sound at \(elapsed)")
}
func playText(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.say("This is a long announcement describing an exercise toes and no toes")
    print("play start sound at \(elapsed)")
}

func playPop(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPopSound()
    print("play chime sound at \(elapsed)")
}
func playTink(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playTinkSound()
    print("play chime sound at \(elapsed)")
}
func playPurr(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPurrSound()
    print("play chime sound at \(elapsed)")
}

func playProgress(elapsed: Double) {
    print("speak progress at \(elapsed)")
}

func playEnd(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPurrSound()
    print("play end at \(elapsed)")
}

func playEndSound(elapsed: Double) {
    let speaker: Speaker = Speaker()
    speaker.playPurrSound()
    print("play end sound at \(elapsed)")
}

func playProgressAnnoucement(text: String)-> ((Double)->Void) {
    return { (elapsed: Double) -> Void in
        let speaker: Speaker = Speaker()
        speaker.say(text)
    }
}
func playText(text: String)-> ((Double)->Void) {
    return { (elapsed: Double) -> Void in
        let speaker: Speaker = Speaker()
        speaker.say(text)
    }
}

func onProgress(elapsed: Double) {
    print("progress at \(elapsed)")
}

func durationOfTasks(tasks: Array<Task>) -> Double {
    return (tasks.last!.elapsed) + 1.0
}

struct Task {
    var elapsed: Double
    var action: (Double) -> ()
}
func buildTasks(exercise: Exercise) -> Array<Task> {
    var tasks = [Task]()
    let announcementDelay: Double = 0.0
    let preludeDelay: Double = 10.0
    let exerciseStartElapsed: Double = announcementDelay + preludeDelay

    tasks.append(Task(elapsed: exerciseStartElapsed - 3.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: exerciseStartElapsed - 2.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: exerciseStartElapsed - 1.0, action: playPurr(elapsed:)))
    for i in 0...exercise.duration - 20 {
        if(i % 10 == 0) {
            let txt: String = "\(10+i)"
            let elapsed: Double = exerciseStartElapsed + 10.0 + Double(i)
            tasks.append(Task(elapsed: elapsed, action: playProgressAnnoucement(text: txt)))
        }
    }
    let tmp = exerciseStartElapsed + Double((exercise.duration - 1))
    tasks.append(Task(elapsed: tmp, action: playProgressAnnoucement(text: "done")))
    var endTime: Double = exerciseStartElapsed + 10.0 * Double((exercise.duration))
    endTime = tasks.last!.elapsed
    tasks.append(Task(elapsed: endTime + 2.0, action: playEndSound(elapsed:)))

    // sort tasks - should be unnecessary
    tasks = tasks.sorted(by: { $0.elapsed < $1.elapsed })
    
    return tasks
}

// Creates a task stack
func buildTasks() -> [Task] {
    var tasks = [Task]()
    tasks.append(Task(elapsed: 0.0, action: playStart(elapsed:)))
    tasks.append(Task(elapsed: 7.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: 8.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: 9.0, action: playPurr(elapsed:)))
    tasks.append(Task(elapsed: 20.0, action: playProgressAnnoucement(text: "10")))
    tasks.append(Task(elapsed: 30.0, action: playProgressAnnoucement(text: "20")))
    tasks.append(Task(elapsed: 40.0, action: playProgressAnnoucement(text: "30")))
    tasks.append(Task(elapsed: 50.0, action: playProgressAnnoucement(text: "40")))
    tasks.append(Task(elapsed: 60.0, action: playProgressAnnoucement(text: "50")))
    tasks.append(Task(elapsed: 62.0, action: playEndSound(elapsed:)))

    // sort tasks
    tasks = tasks.sorted(by: { $0.elapsed < $1.elapsed })
    return tasks
}
// Executes as many pending tasks scheduled for the elapsed time
func attemptToPerformTask(tasks: [Task], elapsed: Double) -> [Task]{
    
    var mutableTasks = tasks
//    print("attemptToPerformTask elapsed: \(elapsed)")
    if (mutableTasks.count > 0 && elapsed > mutableTasks[0].elapsed){
        let nextTask = mutableTasks.removeFirst()
        nextTask.action(nextTask.elapsed)
        
        return attemptToPerformTask(tasks: mutableTasks, elapsed: elapsed)
    }
//    print("attemptToPerformTask:: return nothing to do size: \(mutableTasks.count)")
    return mutableTasks
}


// Executes a task stack
func doPerform(tasks: [Task], frequency: Double, onProgress: @escaping (Double) -> Void) {
    
    var mutableTasks = tasks
    let start = NSDate().timeIntervalSince1970
    let duration: Double = durationOfTasks(tasks: tasks)
    Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { timer in
        let now = NSDate().timeIntervalSince1970
        let elapsed = now - start
        
        mutableTasks = attemptToPerformTask(tasks: mutableTasks, elapsed: elapsed)
        
        if (elapsed > duration) {
            timer.invalidate()
            return
        }
        onProgress(elapsed)
    }
}


class ExerciseRunner: Speaker {
    var frequency: Double
    var exercise: Exercise
    var tasks: Array<Task>
    public var onComplete: (()->())?
    public var onProgressReport: ((Double, Double)->())?
    var timer: Timer?
    var pauseFlag: Bool
    init(exercise: Exercise) {
        self.pauseFlag = false
        self.frequency = 0.1
        self.exercise = exercise
        self.tasks = buildTasks(exercise: self.exercise)
        super.init()
    }
    func go() {
        self.announce(self.exercise)
    }
    override func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("didFinish")
        // note this may be executed not on the main thread
        DispatchQueue.main.async {
            self.doPerform()
        }
    }
    func doPerform() {
        var lastTime = NSDate().timeIntervalSince1970
        var elapsed = 0.0
        let duration: Double = durationOfTasks(tasks: self.tasks)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {timer in
            if self.pauseFlag {
                return
            }
            let now = NSDate().timeIntervalSince1970
            elapsed = elapsed + (now - lastTime)
            lastTime = now
            
            self.tasks = attemptToPerformTask(tasks: self.tasks, elapsed: elapsed)
            
            if (elapsed > duration) {
                timer.invalidate()
                if let cb = self.onComplete {
                    cb()
                    return
                }else {
                    return
                }
            }
            if let cbProgress = self.onProgressReport {
                cbProgress(elapsed, duration)
            }
        }
    }
    @objc func handleTimer() {
        print("timer")
    }
    func togglePause() {
        self.pauseFlag = !self.pauseFlag
    }
}


class SessionModel: ObservableObject {
    var exercises: Array<Exercise>
    var runner: ExerciseRunner?

    @Published var currentExerciseIndex: Int
    @Published var isPaused: Bool
    @Published var isRunning: Bool
    @Published var duration: Double
    @Published var elapsed: Double

    public var progressCallback: ((Double, Double) ->())?
    public var onComplete: (()->())?
    init() {
        self.currentExerciseIndex = 0
        self.exercises = loadExerciseFile()
        self.exercises = Array(self.exercises[0...2])
        self.isPaused = false
        self.isRunning = false
        self.duration = 100.0
        self.elapsed = 0.0
    }
    func go() {
        self.runner = ExerciseRunner(exercise: exercises[self.currentExerciseIndex])
        self.runner!.onComplete = {
            print("runner complete")
            self.next()
        }
        self.runner!.onProgressReport = { (a: Double, b: Double) in
            print("progress report \(a) \(b)")
            self.duration = b
            self.elapsed = a
        }
        self.runner!.go()
    }
    func next() {
        if(self.currentExerciseIndex < self.exercises.count - 1) {
            self.currentExerciseIndex += 1
            self.go()
        } else {
            print("all exercises complete")
            if let cb = self.onComplete {
                cb()
            }
        }
    }
    func prev() {
        self.currentExerciseIndex = (self.currentExerciseIndex + self.exercises.count - 1) % self.exercises.count
        self.go()
    }
    func togglePause() {
        if let r = self.runner {
            r.togglePause()
            self.isPaused = r.pauseFlag
        }
    }
}
class FancyModel: ObservableObject {
    var nbrExercises: Int
    @Published var currentExerciseIndex: Int
    @Published var isPaused: Bool
    @Published var isRunning: Bool
    @Published var duration: Double
    @Published var elapsed: Double

    var exercises: Array<Exercise>
    var sessionRunner: SessionModel
    var timer: Timer?
    var contentView: ContentView?
    
    init (exercises: Array<Exercise>) {
        self.exercises = exercises
        self.nbrExercises = exercises.count
        self.sessionRunner = SessionModel()
        self.isPaused = false
        self.isRunning = false
        self.currentExerciseIndex = 0
        self.duration = 0.0
        self.elapsed = 0.0
    }
}
