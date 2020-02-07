//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var app: App

    var body: some View {

        return VStack(alignment: HorizontalAlignment.center, spacing: 0) {

            Spacer()

            ZStack(alignment: .center) {
                ProgressCircleView(routine: self.app.routineModel)
                ExerciseInfoView(routine: self.app.routineModel)
            }
            
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            
        }
    }
}

