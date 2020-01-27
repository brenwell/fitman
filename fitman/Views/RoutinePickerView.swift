//
//  RoutinePicker.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct RoutinePickerView: View {

    var app: App
    var labels: [String]
    @Binding var selectedExerciseSet: Int

    var body: some View {
        return HStack() {
        
            Picker(selection: $selectedExerciseSet, label: Text("")) {
                ForEach(0 ..< labels.count) {
                   Text(self.labels[$0]).tag($0)
                }
            }.frame(maxWidth: 200)
            
            Button(action: {
                self.app.showMainView = !self.app.showMainView
            }) {
                Image(nsImage: NSImage(named: NSImage.actionTemplateName)! )
            }
        }
    }
}
