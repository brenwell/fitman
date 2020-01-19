//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI



// Allows updating off user default values
// Currently only selectedExerciseSet and preludeDelay
// shows in the top part of the screen before a session starts playing
struct DefaultsTopView: View {
    
    var controller: ExerciseController
    let sessionLabels: [String]
    @Binding var selectedExerciseSet: Int
    @Binding var preludeDelay: String
    var body: some View {
        return VStack(alignment: HorizontalAlignment.center, spacing: 10) {
            HStack() {
                SessionPicker(controller: self.controller, exLabels: sessionLabels, selectedExerciseSet: $selectedExerciseSet).padding(0)
                LayoutPicker()
            }
            HStack() {
                NumberTextField(label: "Prelude Delay", someNumber: $preludeDelay).padding(0)
                NumberTextField(label: "Dummy", someNumber: $preludeDelay).padding(0)
            }

        }.background(Color(.sRGB, white: 0.8, opacity: 1)).padding()
    }
}

fileprivate var layouts: [String] = ["One", "Two"]
struct LayoutPicker: View {

    @State private var layoutIndex: Int = 0 {
        didSet {
            print("layout chosen : \(layouts[layoutIndex])")
        }
    }

    var body: some View {
        return VStack(alignment: HorizontalAlignment.leading) {
        
            Picker(selection: $layoutIndex, label: Text("Select Layout: ")) {
                ForEach(0 ..< layouts.count) {
                   Text(layouts[$0]).tag($0)
                }
            }
        }
    }
}

