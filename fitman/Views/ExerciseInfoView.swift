//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI



struct ExerciseInfoView: View {
    
   @ObservedObject var routine: RoutineModel
    
    @ViewBuilder
    var body: some View {
    
        if routine.state == .stopped {
            StoppedView(routine: routine, label: routine.routine.label, buttonLabel: "Start") {
              self.routine.start()
            }
        }
        else if routine.state == .finished {
            StoppedView(routine: routine, label: "Finished", buttonLabel: "Done") {
                self.routine.reset()
            }
        }
        else {
            ExerciseView(routine: routine)
        }
    }
}

struct StoppedView: View {
    
    @ObservedObject var routine: RoutineModel
    
    var label: String
    var buttonLabel: String
    var action: () -> Void
    
    var body: some View {
        
        let currColor = NSColor(named: NSColor.Name("currentExcerciseLabel"))
        let nextColor = NSColor(named: NSColor.Name("nextExerciseLabel"))
        
        return VStack(alignment: .center, spacing: 20) {
            Row(label: label, fontSize: 60, color: Color(currColor!))
            Row(label: routine.totalDuration, fontSize: 20, color: Color(nextColor!))
            Button(action: action) {
                Text(buttonLabel)
            }
        }
    }
}

struct ExerciseView: View {
    
    @ObservedObject var routine: RoutineModel
    
    var body: some View {
        
        let curr = routine.enabledExercises[safe: routine.currentExerciseIndex]
        let next = routine.enabledExercises[safe: routine.currentExerciseIndex+1]
        let currLabel: String = ((curr) != nil) ? curr!.label : ""
        let nextLabel: String = ((next) != nil) ? next!.label : ""
        let timeLabel: String = "\(Int(routine.duration - routine.elapsed)+1 )"
        let currColor = NSColor(named: NSColor.Name("currentExcerciseLabel"))
        let nextColor = NSColor(named: NSColor.Name("nextExerciseLabel"))
        
        return  VStack(alignment: .center, spacing: 20) {
           Row(label: timeLabel, fontSize: 40, color: Color(nextColor!))
           Row(label: currLabel, fontSize: 60, color: Color(currColor!))
           Row(label: nextLabel, fontSize: 40, color: Color(nextColor!))
        }
    }
}

struct Row: View {
    var label: String
    var fontSize: CGFloat
    var color: Color

    var body: some View {
        
        return HStack(alignment: .center, spacing: 10) {
            Spacer()
            
            HStack(alignment: .bottom, spacing: 10, content: {
                
                Text("\(label)")
                    .font(.custom("Futura", size: fontSize))
                    .foregroundColor(color)
//                    .background(Color.red)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 600)
            })
            
            Spacer()
        }
    }
}
