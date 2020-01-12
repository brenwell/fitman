import SwiftUI

let speaker: Speaker = Speaker()
func playStart(elapsed: Double) {
    speaker.say("This is a long announcement describing an exercise toes and no toes")
    print("play start sound at \(elapsed)")
}
func playText(elapsed: Double) {
    speaker.say("This is a long announcement describing an exercise toes and no toes")
    print("play start sound at \(elapsed)")
}

func playPop(elapsed: Double) {
    speaker.playPopSound()
    print("play chime sound at \(elapsed)")
}
func playTink(elapsed: Double) {
    speaker.playTinkSound()
    print("play chime sound at \(elapsed)")
}
func playPurr(elapsed: Double) {
    speaker.playPurrSound()
    print("play chime sound at \(elapsed)")
}

func playProgress(elapsed: Double) {
    print("speak progress at \(elapsed)")
}

func playEnd(elapsed: Double) {
    speaker.playPurrSound()
    print("play end at \(elapsed)")
}

func playEndSound(elapsed: Double) {
    speaker.playPurrSound()
    print("play end sound at \(elapsed)")
}

func playProgressAnnoucement(text: String)-> ((Double)->Void) {
    return { (elapsed: Double) -> Void in
        speaker.say(text)
    }
}
func playText(text: String)-> ((Double)->Void) {
    return { (elapsed: Double) -> Void in
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
    let announcementDelay: Double = 5.0
    let preludeDelay: Double = 10.0
    let exerciseStartElapsed: Double = announcementDelay + preludeDelay
    let text: String = "\(exercise.label) \(exercise.duration)"
    tasks.append(Task(elapsed: 0.0, action: playText(text: text)))
    //  allow 5 seconds for text to be spoekn
    tasks.append(Task(elapsed: exerciseStartElapsed - 3.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: exerciseStartElapsed - 2.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: exerciseStartElapsed - 1.0, action: playPurr(elapsed:)))
    for i in 0...exercise.duration - 20 {
        if(i % 10 == 0) {
            let txt: String = "\(10+i*10)"
            let elapsed: Double = exerciseStartElapsed + 10.0 + 10.0*Double(i)
            tasks.append(Task(elapsed: elapsed, action: playProgressAnnoucement(text: txt)))
        }
    }
    let endTime: Double = exerciseStartElapsed + 10.0 + 10.0 * Double((exercise.duration-10) % 10)
    tasks.append(Task(elapsed: endTime + 2.0, action: playEndSound(elapsed:)))

    // sort tasks
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

// Executes a task stack
func perform(tasks: [Task], frequency: Double, onProgress: @escaping (Double) -> Void) {
    
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
class FModel {
    var nbrExercises: Int
    var frequency: Double
    @Published var currentExerciseIndex: Int
    @Published var isPaused: Bool
    @Published var isRunning: Bool
    @Published var duration: Double
    @Published var elapsed: Double

    var exercises: Array<Exercise>
    var runner: TaskRunner
    var timer: Timer?
//    var contentView: ContentView?
    
    init (exercises: Array<Exercise>) {
        self.frequency = 0.1
        self.exercises = exercises
        self.nbrExercises = exercises.count
        self.isPaused = false
        self.isRunning = false
        self.currentExerciseIndex = 0
        self.duration = 0.0
        self.elapsed = 0.0
        let tasks: Array<Task> = buildTasks(exercise:self.exercises[self.currentExerciseIndex] )
        self.runner = TaskRunner(tasks: tasks)
    }

    func previous() {
        self.currentExerciseIndex = (self.currentExerciseIndex - 1 + self.nbrExercises) % self.nbrExercises
        self.go()
    }
    
    func next() {
        self.currentExerciseIndex = (self.currentExerciseIndex + 1) % self.nbrExercises
        self.go()
    }
    
    func togglePause() {
        if !self.isRunning {
            self.isRunning = true
            self.go()
            return
        }
        if !self.isPaused {
            flagAsPauseOrStop()
        } else {
            flagAsResumeOrStart()
        }
    }
    
    func flagAsPauseOrStop() {
        enableScreenSleep()
//        self.isRunning = false
        self.isPaused = true
    }
    
    func flagAsResumeOrStart() {
        disableScreenSleep()
//        self.isRunning = true
        self.isPaused = false
    }
    
    func go() {
        
        self.timer?.invalidate()
        let start = NSDate().timeIntervalSince1970
        let tasks: Array<Task> = buildTasks(exercise:self.exercises[self.currentExerciseIndex] )
        self.runner = TaskRunner(tasks: tasks)
        Timer.scheduledTimer(withTimeInterval: self.frequency, repeats: true) { timer in
            let now = NSDate().timeIntervalSince1970
            let elapsed = now - start
            self.handleTimer(elapsed: elapsed)
        }
        flagAsResumeOrStart()
    }
    func handleTimer(elapsed: Double) {
        onProgress(elapsed: elapsed)
        self.runner.handleTimer(elapsed: elapsed)
    }

}
class TaskRunner {
    var tasks: Array<Task>
    init(tasks: Array<Task>) {
        self.tasks = tasks
    }
    func handleTimer(elapsed: Double) {
        self.tasks = attemptToPerformTask(tasks: self.tasks, elapsed: elapsed)
    }
}

// Executes as many pending tasks scheduled for the elapsed time
func attemptToPerformTask(tasks: [Task], elapsed: Double) -> [Task]{
    
    var mutableTasks = tasks
    print("attemptToPerformTask elapsed: \(elapsed)")
    if (mutableTasks.count > 0 && elapsed > mutableTasks[0].elapsed){
        let nextTask = mutableTasks.removeFirst()
        nextTask.action(nextTask.elapsed)
        
        return attemptToPerformTask(tasks: mutableTasks, elapsed: elapsed)
    }
    print("attemptToPerformTask:: return nothing to do size: \(mutableTasks.count)")
    return mutableTasks
}



func fancyTimertest() {
    let frequency: Double = 0.1
    let exercises: Array<Exercise> = loadExerciseFile()
    let tasks = buildTasks(exercise: exercises[0])

    perform(
        tasks: tasks,
        frequency: frequency,
        onProgress: onProgress(elapsed:)
    )
}





