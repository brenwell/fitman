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
    @ObservedObject var model: SessionViewModel
    @State var playPauseLabel: String = "Play"

    var body: some View {
        let sessionLabels: Array<String> = Array(self.controller.exLabels)

        return VStack(alignment: HorizontalAlignment.center, spacing: 20)
        {
            HStack(alignment: .center, spacing: 20)
            {
                Spacer()
                DefaultsTopView(controller: controller,
                    sessionLabels: sessionLabels,
                    selectedExerciseSet: $controller.selectedSessionIndex,
                    preludeDelay: $model.preludeDelayString //$someNumber
                )
                ControlButtons(state: model, playPauseLabel: playPauseLabel)
                Spacer()
            }

            
            RunBottomView(state: model)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(
            controller: exerciseController,
            model: exerciseController.model
            )
        
        return contentView
    }
}

