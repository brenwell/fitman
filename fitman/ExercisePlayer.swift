import SwiftUI
import AVFoundation



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
    let delay = Defaults.shared().preludeDelay
    let preludeDelay: Double = Double(delay) //10.0
    let excDuration: Double = Double(exercise.duration)
    let countInDuration: Double = announcementDelay + preludeDelay
    let totalDuration: Double = countInDuration + excDuration
    
    tasks.append(Task(elapsed: 0.0, action: playExceriseAnnoucement(text: exercise.label, duration: exercise.duration)))
    tasks.append(Task(elapsed: 1.0, action: playExceriseAnnoucement(text: exercise.label, duration: exercise.duration)))
    tasks.append(Task(elapsed: countInDuration - 3.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: countInDuration - 2.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: countInDuration - 1.0, action: playPurr(elapsed:)))

    for i in stride(from: 10, to: exercise.duration, by: 10) {
        let txt: String = "\(i)"
        tasks.append(Task(elapsed: Double(i), action: playProgressAnnoucement(text: txt)))
    }
    
    tasks.append(Task(elapsed: totalDuration - 3.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: totalDuration - 2.0, action: playPop(elapsed:)))
    tasks.append(Task(elapsed: totalDuration - 1.0, action: playPurr(elapsed:)))
    

    // sort tasks - should be unnecessary
//    tasks = tasks.sorted(by: { $0.elapsed < $1.elapsed })
    
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
    return mutableTasks
}


// Plays a single Exercise allowing the play to be paused and restarted.
// Creating another instance of this class for each new Exercise
//
class ExercisePlayer {
    
    public var onComplete: (()->())?
    public var onProgressReport: ((Double, Double)->())?
    
    var frequency: Double
    var exercise: Exercise
    var tasks: Array<Task>
    var timer: Timer?
    var pauseFlag: Bool
    var runningFlag: Bool
    
    init(exercise: Exercise) {
        self.pauseFlag = false
        self.runningFlag = false
        
        self.frequency = 0.2
        self.exercise = exercise
        self.tasks = buildTasks(exercise: self.exercise)
    }
    public func go() {
        self.doPerform()
    }
    public func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
    public func togglePause() {
        self.pauseFlag = !self.pauseFlag
        
        if (self.pauseFlag) {
            pauseAnnouncement()
        }else {
            resumeAnnouncement()
        }
    }
    private func doPerform() {
        var lastTime = NSDate().timeIntervalSince1970
        var elapsed = 0.0
        let duration: Double = durationOfTasks(tasks: self.tasks)
        self.runningFlag = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) {timer in
            if self.pauseFlag {
                return
            }
            let now = NSDate().timeIntervalSince1970
            elapsed = elapsed + (now - lastTime)
            lastTime = now
            
            self.tasks = attemptToPerformTask(tasks: self.tasks, elapsed: elapsed)

            if let cbProgress = self.onProgressReport {
                cbProgress(elapsed, duration)
            }

            if (elapsed > duration) {
                timer.invalidate()
                self.timer = nil
                self.runningFlag = false
                if let cb = self.onComplete {
                    cb()
                    return
                }else {
                    return
                }
            }
        }
    }

}
