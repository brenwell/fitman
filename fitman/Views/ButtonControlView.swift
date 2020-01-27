//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI


struct ButtonControlView: View {
    @ObservedObject var state: RoutineModel
    @State var playPauseLabel: String = "Play"

    var body: some View {
        return HStack(alignment: .center) {
                        
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
