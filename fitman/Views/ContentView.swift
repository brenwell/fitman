//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

fileprivate let flag = false

struct XContentView: View {
    
    var controller: ExerciseController
    let sessionLabels: [String]
    var previousSelectedExerciseSet: Int = 0 // redundant
    
    @ObservedObject var state: SessionViewModel
    @State var current: Int
    @State var playPauseLabel: String = "Play"
    @State var selectedExerciseSet: Int
    @State var someNumber = "999"
    var body: some View {

        return VStack(alignment: HorizontalAlignment.center, spacing: 20) {
        
            HStack(alignment: .center, spacing: 20)
            {
                Spacer()
                if ( (state.buttonState != ViewModelState.Playing)
                    && (state.buttonState != ViewModelState.Paused)) {
                    SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet)
                    Text("Prelude Delay: ")
//                    NumberTextField(someNumber: $someNumber)
                    Spacer()
                } else {
                    VStack() {
                    Text("Playing Session: \(self.sessionLabels[self.selectedExerciseSet])")
                    }
                    Spacer()
                    
                }
            }
            HStack(alignment: .center, spacing: 20) {
                ControlButtons(state: state, playPauseLabel: playPauseLabel)
            }.padding(10)

            if (flag) {
                CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
                }
            Spacer()

            ZStack(alignment: .center) {
                ProgressCircle(session: self.state)
                if (!flag) {
                    CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
                }
            }
            Spacer()
        }.background(Color(.sRGB, white: 0.8, opacity: 1))
        
    }
}
