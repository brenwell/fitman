//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var store: Store

    var body: some View {

        return VStack(alignment: HorizontalAlignment.center, spacing: 0) {

            Spacer()

            ZStack(alignment: .center) {
                ProgressCircleView(routine: self.store.selectedRoutine)
                ExerciseInfoView(routine: self.store.selectedRoutine)
            }
            
            
            
            Spacer()
            
        }
    }
}

