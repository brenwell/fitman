//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

fileprivate let flag = false

// Structire the app as a single view
struct ContentView: View {
    
    @ObservedObject var controller: ExerciseController
    let sessionLabels: [String]
//    var previousSelectedExerciseSet: Int = 0
    
    @ObservedObject var state: SessionViewModel
//    @State var current: Int
    @State var playPauseLabel: String = "Play"
//    @State var selectedExerciseSet: Int
    @State var someNumber = "999"
    var body: some View {

        return VStack(alignment: HorizontalAlignment.center, spacing: 20)
        {
            if ( (state.buttonState != ViewModelState.Playing)
                && (state.buttonState != ViewModelState.Paused)) {
                HStack(alignment: .center, spacing: 20)
                {
                    Spacer()
                    DefaultsTopView(controller: controller,
                        sessionLabels: sessionLabels,
                        selectedExerciseSet: $controller.selectedSessionIndex,
                        
                        preludeDelay: $someNumber
                        )
                    Spacer()
                }
            } else {
                HStack(alignment: .center, spacing: 20)
                {
                    Spacer()
                    RunTopView(sessionName: "\(self.sessionLabels[self.controller.selectedSessionIndex])")
                    Spacer()
                }
            }
            ExDivider()
            HStack(alignment: .center, spacing: 20)
            {
                ControlButtons(state: state, playPauseLabel: playPauseLabel)
            }.padding(10)
            RunBottomView(state: state, discFlag: flag)
        }.background(Color(.sRGB, white: 0.8, opacity: 1))
        
    }
}
// custom divider between top and bottom part of screen
struct ExDivider: View {
    let color: Color = .black
    let width: CGFloat = 2
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(
            controller: exerciseController,
            sessionLabels: exerciseController.exLabels,
            state: exerciseController.model,
            someNumber: exerciseController.model.preludeDelayString
            )
        
        return contentView
    }
}

