//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct BottomView: View {
    
    @ObservedObject var routine: RoutineModel
    
    var body: some View {
        
        return HStack(alignment: .center, spacing: 20)
        {
            Text("\(routine.currentExerciseIndex) / \(routine.enabledExercises.count)")
            Spacer() 
            Text(routine.totalDuration)
        
        }.padding(10)

    }
}
