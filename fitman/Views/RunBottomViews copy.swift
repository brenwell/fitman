//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct RunBottomView: View {
    @ObservedObject var state: SessionViewModel
    var discFlag: Bool
//    @State var playPauseLabel: String = "Play"

    var body: some View {
        let flag: Bool = self.discFlag
        return VStack(alignment: HorizontalAlignment.center, spacing: 0) {
            if (flag) {
                CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
                Spacer()

                ZStack(alignment: .center) {
                    ProgressCircle(session: self.state, discFlag: flag)
                    if (!flag) {
                        CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
                    }
                }
                Spacer()
            } else {
                Spacer()

                ZStack(alignment: .center) {
                    ProgressCircle(session: self.state, discFlag: flag)
                    CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
                }
                Spacer()
            }
        }.background(Color(.sRGB, white: 0.8, opacity: 1))
    }
}

