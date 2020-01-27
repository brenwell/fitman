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
    
    var body: some View {
    
        let curr = routine.routine.exercises[safe: routine.currentExerciseIndex]
        let next = routine.routine.exercises[safe: routine.currentExerciseIndex+1]
        let currLabel: String = ((curr) != nil) ? curr!.label : ""
        let nextLabel: String = ((next) != nil) ? next!.label : ""
        let timeLabel: String = "\(Int(routine.duration - routine.elapsed))"
        
        return VStack(alignment: .center, spacing: 20) {
            Row(labelStr: timeLabel, isCurrent: false)
            Row(labelStr: currLabel, isCurrent: true)
            Row(labelStr: nextLabel, isCurrent: false)
        }
    }
}



struct Row: View {
    var labelStr: String
    var isCurrent: Bool

    var body: some View {
        
        let currColor = NSColor(named: NSColor.Name("currentExcerciseLabel"))
        let nextColor = NSColor(named: NSColor.Name("nextExerciseLabel"))
    
        let fontSize: CGFloat = !isCurrent ? 40 : 60
        let fontColor: Color = !isCurrent ? Color(nextColor!) : Color(currColor!)
        
        
        return HStack(alignment: .center, spacing: 10) {
            Spacer()
            HStack(alignment: .bottom, spacing: 10, content: {
                
                Text("\(labelStr)")
                    .font(.custom("Futura", size: fontSize))
                    .foregroundColor(fontColor)
            })
            Spacer()
        }
    }
}
