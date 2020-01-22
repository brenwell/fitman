//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI



// Allows updating off user default values
// Currently only selectedExerciseSet and preludeDelay
// shows in the top part of the screen before a session starts playing
struct DefaultsTopView: View {
    
    var controller: ExerciseController
    let sessionLabels: [String]
    @Binding var selectedExerciseSet: Int
    @Binding var preludeDelay: String
    var body: some View {
        return VStack(alignment: HorizontalAlignment.center) {
            HStack() {
                SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet).padding(0)
            }
        }.padding(10)
    }
}

