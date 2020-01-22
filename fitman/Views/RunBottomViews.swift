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


    var body: some View {

        return VStack(alignment: HorizontalAlignment.center, spacing: 0) {

            Spacer()

            ZStack(alignment: .center) {
                ProgressCircle(session: self.state)
                CurrentPrevNextView(session: self.state, current: self.state.currentExerciseIndex)
            }
            Text("\(state.elapsed)")

            Spacer()
            
        }
    }
}

