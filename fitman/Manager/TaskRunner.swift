import SwiftUI


struct Task {
    var elapsed: Double
    var action: (Double) -> ()
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

class TaskRunner {
    
    var elapsed: Double = 0.0
    var lastTime: TimeInterval?
    var isPaused: Bool = false
    var timer: Timer?
    
    // Executes a task stack
    private func perform(
        tasks: [Task],
        frequency: Double,
        duration: Int,
        onProgress: @escaping (Double, Double) -> Void,
        onComplete: @escaping () -> Void) {
        
        var mutableTasks = tasks
        self.lastTime = NSDate().timeIntervalSince1970
        
        self.timer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true) { timer in
            
            if (self.elapsed > Double(duration)) {
                self.stop()
                onComplete()
                return
            }
            
            if self.isPaused { return }
            
            let now = NSDate().timeIntervalSince1970
            self.elapsed += now - self.lastTime!
            self.lastTime = now
            
            mutableTasks = attemptToPerformTask(tasks: mutableTasks, elapsed: self.elapsed)
            
//            print("\(Int(self.elapsed/Double(duration)*100))%") // Percent
            
            onProgress(self.elapsed, Double(duration))
        }
    }
    
    func start(
        tasks: [Task],
        frequency: Double,
        duration: Int,
        onProgress: @escaping (Double, Double) -> Void,
        onComplete: @escaping () -> Void
    ) {
        
        self.stop()
        
        self.perform(
            tasks: tasks,
            frequency: frequency,
            duration: duration,
            onProgress: onProgress,
            onComplete: onComplete
        )
        
    }

    func resume() {
        self.lastTime = NSDate().timeIntervalSince1970
        
        self.isPaused = false
    }
    
    func pause() {
        self.isPaused = true
    }
    
    func stop() {
        self.elapsed = 0.0
        self.timer?.invalidate()
    }
}

