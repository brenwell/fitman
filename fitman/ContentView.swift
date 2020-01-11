//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var controller: ExerciseController
    let sessionLabels: [String]
    var previousSelectedExerciseSet: Int = 0
    
    @ObservedObject var state: SessionModel
    @State var current: Int
    @State var playPauseLabel: String = "Play"
    @State var selectedExerciseSet = 0
    
    var body: some View {

        return VStack(alignment: HorizontalAlignment.center, spacing: 20) {
        
            HStack(alignment: .center, spacing: 20)
            {
                SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet)
//                Spacer()
                ControlButtons(state: state, playPauseLabel: playPauseLabel)
            }.padding(10)

            CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
//            Spacer()

            ZStack(alignment: .center) {
                ProgressCircle(session: self.state)
            }

            Spacer()
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(
            controller: exerciseController,
            sessionLabels: exerciseController.exLabels,
            state: exerciseController.model,
            current: exerciseController.model.currentExerciseIndex)
        
        return contentView
    }
}

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
            }.onReceive([self.selectedExerciseSet].publisher.first()) { (value) in
                print("onReceive selected value \(value)")
                self.controller.changeSession(value: value)
            }
//            Text(" Selected Exercise Set: \(exLabels[selectedExerciseSet])")
        }
    }
}

struct ControlButtons: View {
    @ObservedObject var state: SessionModel
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
                self.playPauseLabel = !self.state.isPaused ? "Pause" : "Play"
            }) {
                    Text(self.playPauseLabel)
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

    @ObservedObject var session: SessionModel
    
    var body: some View {
//        var pdone: Double = self.state.elapsed / self.state.duration
//        print("elapsed:: \($state.elapsed) duration::  \(self.state.duration)")
        return Slider(value: $session.elapsed, in: 0.0...self.session.duration)
    }
}

struct ProgressCircle: View {

//    @ObservedObject var session: ExerciseModel
    @ObservedObject var session: SessionModel

    var body: some View {
        
        let width: CGFloat = 250.0
        let frameWidth: CGFloat = 250.0
        
        let bgColor = NSColor(named: NSColor.Name("progressBarBg"))
        let barColor = NSColor(named: NSColor.Name("Progressbar"))
//        let barColor = (session.stateMachine?.state != SM_State.prelude)
//            ? NSColor(named: NSColor.Name("exerciseProgressBar"))
//            : NSColor(named: NSColor.Name("countInProgressBar"))
        
        return ZStack {
            Circle()
                .stroke(Color(bgColor!), lineWidth: width)
                .frame(width: frameWidth)
                .rotationEffect(Angle(degrees:-90))
            Circle()
                .trim(from: 0.0, to: CGFloat(session.elapsed / session.duration))
                .stroke(Color(barColor!), lineWidth: width)
                .frame(width: frameWidth)
                .rotationEffect(Angle(degrees:-90))
        }
    }
}

extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct CurrentPrevNextView: View {
    @ObservedObject var session: SessionModel
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

    @ObservedObject var session: SessionModel
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
