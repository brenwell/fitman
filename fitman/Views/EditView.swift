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
                
                    ForEach(exercises) { exercise in
                        
                        HStack(){
                        
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
                            
                            Toggle("", isOn: Binding(
                              get: {
                                return exercise.enabled
                                },
                              set: { (newValue) in
                                return self.store.changeExerciseEnabled(enabled: newValue, index: exercise.id)
                            }))
                            
                        }
                        
                    }
                

            }.frame(maxWidth: 600)
        }
    }
}

