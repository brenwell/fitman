//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var state: ExerciseModel
    @State var current: Int
    @State var playPauseLabel: String = "Play"
    
    var body: some View {
        
        VStack(alignment: HorizontalAlignment.center, spacing: 20) {
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

            SessionView(session: self.state, current: self.current)

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

//
//struct Session1View: View {
//
//    @Binding var session: ExerciseModel
//    @Binding var current: Int
//
//    var body: some View {
////        List(session.exercises) { exercise in
////            Row(excercise: exercise, currentIndex: self.session.currentExerciseIndex)
////        }
//        List {
//            ForEach(0 ..< session.exercises.count) { index -> Row in
////                let isCurrent = self.session.currentExerciseIndex == index
//                let isCurrent = self.current == index
//                return Row(exercise: self.session.exercises[index], isCurrent: isCurrent)
//            }
//        }
//    }
//
//}

struct SessionView: View {

    @Binding var session: ExerciseModel
    @Binding var current: Int
    @State var isCurrent: Bool
    
    var body: some View {
//        List(session.exercises) { exercise in
//            Row(excercise: exercise, currentIndex: self.session.currentExerciseIndex)
//        }
        List {
            ForEach(0 ..< session.exercises.count) { index -> Row in
//                let isCurrent = self.session.currentExerciseIndex == index
                self.isCurrent = self.current == index
                return Row(exercise: self.$session.exercises[index], isCurrent: self.$isCurrent)
                
            }
        }
    }
    
}

struct Row: View {
    @Binding var exercise: Exercise
    @Binding var isCurrent: Bool

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
