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
                
                TextField(store.selectedRoutine.routine.label, text: Binding(
                  get: {
                    return self.store.selectedRoutine.routine.label
                    },
                  set: { (newValue) in
                    return self.store.changeRoutineLabel(label: newValue)
                }))
                
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
                        }))
                        
                        TextField("\(exercise.duration)", text: Binding(
                          get: {
                            return "\(exercise.duration)"
                            },
                          set: { (newValue) in
                            return self.store.changeExerciseDuration(duration: newValue, index: exercise.id)
                        }))
                        
                        Button(action: {
                            self.store.removeExercise(index: exercise.id)
                        }) {
                            Image(nsImage: NSImage(named: NSImage.removeTemplateName)! )
                        }
                        
                    }
                    
                }
                
                

            }.frame(maxWidth: 600)
            
            HStack() {
            
                        Spacer()
                        Button(action: {
                            self.store.addExercise()
                        }) {
                            Image(nsImage: NSImage(named: NSImage.addTemplateName)! )
                        }
                    
                
            }.frame(maxWidth: 600)
            

        }
    }
}

