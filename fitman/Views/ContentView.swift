//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

// Structire the app as a single view
struct ContentView: View {
    
    @ObservedObject var app: App
    
    var body: some View {
        
        let labels = app.database.routines.map { $0.label }

        return VStack(alignment: HorizontalAlignment.center, spacing: 20)
        {
            HStack(alignment: .center, spacing: 20)
            {
                RoutinePickerView(app: self.app, labels: labels, selectedExerciseSet: $app.selectedSessionIndex).padding(0)
                
                Spacer()
                
                ButtonControlView(state: app.routineModel)
                
            
            }.padding(10)

            
            MainContentView(app: app)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = App()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(app: exerciseController)
        
        return contentView
    }
}

