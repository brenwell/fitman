//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct EditView: View {
    
    @ObservedObject var store: Store
    
    var body: some View {
        
        let exercises = store.selectedRoutine.routine.exercises

        return ScrollView() {
            
            VStack(alignment: HorizontalAlignment.center) {
                
                HStack() {
                    
                    TextField(store.selectedRoutine.routine.label, text: Binding(
                      get: {
                        return self.store.selectedRoutine.routine.label
                        },
                      set: { (newValue) in
                        return self.store.changeRoutineLabel(label: newValue)
                    }))
                        .font(.custom("Futura", size: 20))
                        .padding(5)
                        .background(Color.clear)
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    Spacer()
                    
                    Text("Duration between")
                    
                    TextField("\(Int(store.selectedRoutine.routine.gap))", text: Binding(
                      get: {
                        return "\(Int(self.store.selectedRoutine.routine.gap))"
                        },
                      set: { (newValue) in
                        return self.store.changeRoutineGap(gap: newValue)
                    })).frame(maxWidth: 50).textFieldStyle(PlainTextFieldStyle()).padding(5).background(Color.white.opacity(0.1))
                }
                
                ForEach(exercises) { exercise in
                    
                    HStack(){
   
                        Toggle("", isOn: Binding(
                          get: {
                            return exercise.enabled
                            },
                          set: { (newValue) in
                            return self.store.changeExerciseEnabled(enabled: newValue, index: exercise.id)
                        }))
                        
                        TextField(exercise.label, text: Binding(
                          get: {
                            return exercise.label
                            },
                          set: { (newValue) in
                            return self.store.changeExerciseLabel(label: newValue, index: exercise.id)
                        })).textFieldStyle(PlainTextFieldStyle()).padding(5).background(Color.white.opacity(0.1))
                        
                        TextField("\(exercise.duration)", text: Binding(
                          get: {
                            return "\(exercise.duration)"
                            },
                          set: { (newValue) in
                            return self.store.changeExerciseDuration(duration: newValue, index: exercise.id)
                            })).textFieldStyle(PlainTextFieldStyle()).padding(5).background(Color.white.opacity(0.1))
                        
                        Button(action: {
                            self.store.removeExercise(index: exercise.id)
                        }) {
                            Image(nsImage: NSImage(named: NSImage.stopProgressTemplateName)! )
                        }.buttonStyle(PlainButtonStyle()).padding(8).background(Color.white.opacity(0.1))
                        
                    }
                    
                }
                
                

            }.frame(maxWidth: 600)
            
            HStack() {
            
                        Spacer()
                        Button(action: {
                            self.store.addExercise()
                        }) {
                            Image(nsImage: NSImage(named: NSImage.addTemplateName)! )
                        }.buttonStyle(PlainButtonStyle()).padding(8).background(Color.white.opacity(0.1))
                    
                
            }.frame(maxWidth: 600)
            

        }
    }
}

