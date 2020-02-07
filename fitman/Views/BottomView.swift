//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct BottomView: View {
    
    @ObservedObject var store: Store

    var body: some View {

        return HStack(alignment: .center, spacing: 20)
        {
            Text("\(store.selectedRoutine.currentExerciseIndex) / \(store.selectedRoutine.enabledExercises.count)")
            Spacer() 
            Text(store.selectedRoutine.totalDuration)
        
        }.padding(10)

    }
}
