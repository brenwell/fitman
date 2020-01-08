//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var state: ExerciseModel
    @State var current: Int
    @State var playPauseLabel: String = "Play"
    var body: some View {
            
        print("elapsed: \(self.state.elapsed) duration: \(self.state.duration) % \(self.state.elapsed/self.state.duration*100.0)")
        return VStack(alignment: HorizontalAlignment.center, spacing: 20) {
            Spacer()
            HStack(alignment: .center, spacing: 20)
            {
                Spacer()
                Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Excercise")) {
                    /*@START_MENU_TOKEN@*/Text("1").tag(1)/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("2").tag(2)/*@END_MENU_TOKEN@*/
                }
                Spacer()
            }

            SessionView(session: self.state, current: self.state.currentExerciseIndex)
            
            ProgressBar(session: self.state)

            HStack(alignment: .center, spacing: 20) {
                    Button(action: {
                    self.state.previous()
                }) {
                    Text("Previous")
                }
                Button(action: {
                    self.state.togglePause()
                    self.playPauseLabel = !self.state.isPaused ? "Pause" : "Play"
                }) {
//                    Text(!self.state.isPaused ? "Start" : "Stop")
                        Text(self.playPauseLabel)
                }
                Button(action: {
                    self.state.next()
                }) {
                    Text("Next")
                }
            }
            Spacer()
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(state: exerciseController.model, current: exerciseController.model.currentExerciseIndex)
        
        return contentView
    }
}

struct ProgressBar: View {

    @ObservedObject var session: ExerciseModel
    
    var body: some View {
//        var pdone: Double = self.state.elapsed / self.state.duration
//        print("elapsed:: \($state.elapsed) duration::  \(self.state.duration)")
        return Slider(value: $session.elapsed, in: 0.0...self.session.duration)
    }
}


struct SessionView: View {

    @ObservedObject var session: ExerciseModel
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
    var exercise: Exercise
    var isCurrent: Bool

    var body: some View {
    
        let fontColor: Color = !isCurrent ? .black : .green
    
        return HStack(alignment: .center, spacing: 10) {
            Spacer()
            HStack(alignment: .bottom, spacing: 10, content: {
                
                Text("\(exercise.label)")
                    .font(.custom("Futura", size: 20))
                    .foregroundColor(fontColor)
                
                Text("\(exercise.duration)s")
                    .font(.custom("Futura", size: 13))
                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
            })
            Spacer()
        }
    }
}
