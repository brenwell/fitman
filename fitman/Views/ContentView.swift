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
    
    @ObservedObject var controller: ExerciseController
    @State var playPauseLabel: String = "Play"

    var body: some View {
        let sessionLabels: Array<String> = Array(self.controller.exLabels)

        return VStack(alignment: HorizontalAlignment.center, spacing: 20)
        {
            HStack(alignment: .center, spacing: 20)
            {
                
                DefaultsTopView(controller: controller,
                    sessionLabels: sessionLabels,
                    selectedExerciseSet: $controller.selectedSessionIndex
                )
                Spacer()
                
                ControlButtons(state: controller.model, playPauseLabel: playPauseLabel)
                
            
            }.padding(10)

            
            RunBottomView(state: controller.model)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(controller: exerciseController)
        
        return contentView
    }
}

