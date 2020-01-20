//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI
fileprivate let flag: Bool = false

//
// picks the exercise session to run.
// Made into a separate View so that it is not updated by progress reporting
//
struct SessionPicker: View {

    var controller: ExerciseController
    var exLabels: [String]
    @Binding var selectedExerciseSet: Int

    var body: some View {
        return VStack(alignment: HorizontalAlignment.leading) {
        
            Picker(selection: $selectedExerciseSet, label: Text("Select Exercise Set from:")) {
                ForEach(0 ..< exLabels.count) {
                   Text(self.exLabels[$0]).tag($0)
                }
            }
        }
    }
}

struct ControlButtons: View {
    @ObservedObject var state: SessionViewModel
    @State var playPauseLabel: String = "Play"

    var body: some View {
        return HStack(alignment: .center, spacing: 20) {
            Button(action: {
                self.state.previous()
            }) {
                Text("Previous")
            }
            Button(action: {
                self.state.togglePause()
            }) {
                    Text(self.state.buttonLabel)
            }
            Button(action: {
                self.state.next()
            }) {
                Text("Next")
            }
        }
    }
}

struct ProgressBar: View {

    @ObservedObject var session: SessionViewModel
    
    var body: some View {
//        var pdone: Double = self.state.elapsed / self.state.duration
//        print("elapsed:: \($state.elapsed) duration::  \(self.state.duration)")
        return Slider(value: $session.elapsed, in: 0.0...self.session.duration)
    }
}


extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct CurrentPrevNextView: View {
    @ObservedObject var session: SessionViewModel
    var current: Int
    
    var body: some View {
    
//        let prev = session.exercises[safe: current-1]
        let curr = session.exercises[safe: current]
        let next = session.exercises[safe: current+1]
        
        return VStack(alignment: .center, spacing: 20) {
//            Row(exercise: prev, isCurrent: false)
            Row(exercise: curr, isCurrent: true)
            Row(exercise: next, isCurrent: false)
        }
    }
}

struct SessionView: View {

    @ObservedObject var session: SessionViewModel
    var current: Int
    
    var body: some View {
//        List(session.exercises) { exercise in
//            Row(excercise: exercise, currentIndex: self.session.currentExerciseIndex)
//        }
        List {
            ForEach(0 ..< session.exercises.count) { index -> Row in
//                let isCurrent = self.session.currentExerciseIndex == index
                let isCurrent = self.current == index
                return Row(exercise: self.session.exercises[index], isCurrent: isCurrent)
                
            }
        }
    }
    
}

struct Row: View {
    var exercise: Exercise?
    var isCurrent: Bool

    var body: some View {
        
        let currColor = NSColor(named: NSColor.Name("currentExcerciseLabel"))
        let nextColor = NSColor(named: NSColor.Name("nextExerciseLabel"))
    
        let fontSize: CGFloat = !isCurrent ? 40 : 60
        let fontColor: Color = !isCurrent ? Color(nextColor!) : Color(currColor!)
        let labelStr: String = (exercise != nil) ? exercise!.label : " "
//        let durationStr: String = (exercise != nil) ? String(exercise!.duration) : " "
        
        return HStack(alignment: .center, spacing: 10) {
            Spacer()
            HStack(alignment: .bottom, spacing: 10, content: {
                
                Text("\(labelStr)")
                    .font(.custom("Futura", size: fontSize))
                    .foregroundColor(fontColor)
                    
                
//                Text("\(durationStr)s")
//                    .font(.custom("Futura", size: 13))
//                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
//                    .baselineOffset(8)
            })
            Spacer()
        }
    }
}
