//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct RunView: View {
    @ObservedObject var state: SessionViewModel
    @State var playPauseLabel: String = "Play"

    var body: some View {

        return VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            ControlButtons(state: state, playPauseLabel: playPauseLabel)
            CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
            VStack(alignment: .center) {
            ProgressCircle(session: self.state)
            }.background(Color(.sRGB, white: 0.8, opacity: 1))
        }
    }
}

