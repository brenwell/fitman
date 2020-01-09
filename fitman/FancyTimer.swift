import SwiftUI


func playStart(elapsed: Double) {
    print("play start sound at \(elapsed)")
}

func playChime(elapsed: Double) {
    print("play chime sound at \(elapsed)")
}

func playProgress(elapsed: Double) {
    print("speak progress at \(elapsed)")
}

func playEnd(elapsed: Double) {
    print("play end sound at \(elapsed)")
}

func onProgress(elapsed: Double) {
//    print("progress at \(elapsed)")
}

struct Task {
    var elapsed: Double
    var action: (Double) -> ()
}

// Creates a task stack
func buildTasks(duration: Int) -> [Task] {
    
    // create stack
    var tasks = [Task]()

    // add repeating tasks
    for i in stride(from: 10, to: duration, by: 10) {
        tasks.append(Task(elapsed: Double(i), action: playProgress(elapsed:)))
    }
    
    // cast duration
    let d = Double(duration)

    // add single tasks
    tasks.append(Task(elapsed: 0.0, action: playStart(elapsed:)))
    tasks.append(Task(elapsed: d - 3.0, action: playChime(elapsed:)))
    tasks.append(Task(elapsed: d - 2.0, action: playChime(elapsed:)))
    tasks.append(Task(elapsed: d - 1.0, action: playChime(elapsed:)))
    tasks.append(Task(elapsed: d, action: playEnd(elapsed:)))
    
    // sort tasks
    tasks = tasks.sorted(by: { $0.elapsed < $1.elapsed })
    
    return tasks
}

// Executes a task stack
func perform(tasks: [Task], frequency: Double, duration: Int, onProgress: @escaping (Double) -> Void) {
    
    var mutableTasks = tasks
    let start = NSDate().timeIntervalSince1970
    
    Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { timer in
        let now = NSDate().timeIntervalSince1970
        let elapsed = now - start
        
        mutableTasks = attemptToPerformTask(tasks: mutableTasks, elapsed: elapsed)
        
        if (elapsed > Double(duration)) {
            timer.invalidate()
            return
        }
        
        onProgress(elapsed)
    }
}

// Executes as many pending tasks scheduled for the elapsed time
func attemptToPerformTask(tasks: [Task], elapsed: Double) -> [Task]{
    
    var mutableTasks = tasks
    
    if (mutableTasks.count > 0 && elapsed > mutableTasks[0].elapsed){
        let nextTask = mutableTasks.removeFirst()
        nextTask.action(nextTask.elapsed)
        
        return attemptToPerformTask(tasks: mutableTasks, elapsed: elapsed)
    }
    
    return mutableTasks
}

func main(){
    let frequency: Double = 0.1
    let duration: Int = 40
    let tasks = buildTasks(duration: duration)
    
    perform(
        tasks: tasks,
        frequency: frequency,
        duration: duration,
        onProgress: onProgress(elapsed:)
    )
}

//main()



