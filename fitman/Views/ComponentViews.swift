//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI
fileprivate let flag: Bool = false

//
// picks the exercise session to run.
// Made into a separate View so that it is not updated by progress reporting
//
struct SessionPicker: View {

    var controller: ExerciseController
    var exLabels: [String]
    @Binding var selectedExerciseSet: Int

    var body: some View {
        return VStack(alignment: HorizontalAlignment.leading) {
        
            Picker(selection: $selectedExerciseSet, label: Text("Select Exercise Set from:")) {
                ForEach(0 ..< exLabels.count) {
                   Text(self.exLabels[$0]).tag($0)
                }
            }
        }
    }
}

struct ControlButtons: View {
    @ObservedObject var state: SessionViewModel
    @State var playPauseLabel: String = "Play"

    var body: some View {
        return HStack(alignment: .center, spacing: 20) {
                        
            Button(action: {
                self.state.previous()
            }) {
                Image(nsImage: NSImage(named: NSImage.goLeftTemplateName)! )
            }
            Button(action: {
                self.state.togglePause()
            }) {
                    Text(playPauseLabel)
            }
            Button(action: {
                self.state.next()
            }) {
                Image(nsImage: NSImage(named: NSImage.goRightTemplateName)! )
            }
        }
    }
}

struct ProgressBar: View {

    @ObservedObject var session: SessionViewModel
    
    var body: some View {
//        var pdone: Double = self.state.elapsed / self.state.duration
//        print("elapsed:: \($state.elapsed) duration::  \(self.state.duration)")
        return Slider(value: $session.elapsed, in: 0.0...self.session.duration)
    }
}


extension Collection {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct CurrentPrevNextView: View {
    @ObservedObject var session: SessionViewModel
    var current: Int
    
    var body: some View {
    
        let curr = session.exercises[safe: current]
        let next = session.exercises[safe: current+1]
        let currLabel: String = ((curr) != nil) ? curr!.label : ""
        let nextLabel: String = ((next) != nil) ? next!.label : ""
        let timeLabel: String = "\(Int(session.elapsed))"
        
        return VStack(alignment: .center, spacing: 20) {
            Row(labelStr: timeLabel, isCurrent: false)
            Row(labelStr: currLabel, isCurrent: true)
            Row(labelStr: nextLabel, isCurrent: false)
        }
    }
}



struct Row: View {
    var labelStr: String
    var isCurrent: Bool

    var body: some View {
        
        let currColor = NSColor(named: NSColor.Name("currentExcerciseLabel"))
        let nextColor = NSColor(named: NSColor.Name("nextExerciseLabel"))
    
        let fontSize: CGFloat = !isCurrent ? 40 : 60
        let fontColor: Color = !isCurrent ? Color(nextColor!) : Color(currColor!)
        
        
        return HStack(alignment: .center, spacing: 10) {
            Spacer()
            HStack(alignment: .bottom, spacing: 10, content: {
                
                Text("\(labelStr)")
                    .font(.custom("Futura", size: fontSize))
                    .foregroundColor(fontColor)
            })
            Spacer()
        }
    }
}
