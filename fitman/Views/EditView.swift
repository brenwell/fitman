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

        return ScrollView() {
            VStack(alignment: HorizontalAlignment.center) {
            
                ForEach(app.routineModel.routine.exercises, id: \.id) { exercise in
                    ListRow(exercise: exercise)
                }
            }
        }.padding(20)
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
                return self.exercise.duration = Int(newValue)!
            }))
            
        }
    }
}
