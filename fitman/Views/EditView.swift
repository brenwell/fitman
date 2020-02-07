//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct EditView: View {
    
    @ObservedObject var app: App
    
    var body: some View {
        
        let exercises = app.routineModel.routine.exercises

        return ScrollView() {
            VStack(alignment: HorizontalAlignment.center) {
                
                    ForEach(exercises) { exercise in
                        HStack(){
                        TextField(exercise.label, text: Binding(
                          get: {
                            return exercise.label
                            },
                          set: { (newValue) in
                            return self.app.changeExerciseLabel(label: newValue, index: exercise.id)
                        }))
                        
                        TextField("\(exercise.duration)", text: Binding(
                          get: {
                            return "\(exercise.duration)"
                            },
                          set: { (newValue) in
                            return self.app.changeExerciseDuration(duration: newValue, index: exercise.id)
                        }))
                            }
                    }
                

            }.frame(maxWidth: 600)
        }
    }
}


struct ListRow: View {
    @State var exercise: Exercise
    

    var body: some View {
        print(exercise)
        return HStack {

            TextField(exercise.label, text: Binding(
              get: {
                return self.exercise.label
                },
              set: { (newValue) in
                return self.exercise.label = newValue
            }))
            
            TextField("", text: Binding(
              get: {
                return "\(self.exercise.duration)"
                },
              set: { (newValue) in
                if (newValue == "") { return }
                self.exercise.duration = Int(newValue)!
                print(self.exercise)

                return
            }))
            
        }
    }
}
