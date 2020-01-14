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
struct DefaultsView: View {
    
    var controller: ExerciseController
    let sessionLabels: [String]
    @Binding var selectedExerciseSet: Int
    @Binding var preludeDelay: Int
    var body: some View {
        return VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet)
            Text("Prelude Delay: ")
//            NumberTextField(someNumber: $preludeDelay)
            Spacer()

        }.background(Color(.sRGB, white: 0.8, opacity: 1))
    }
}

