//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI


struct ButtonControlView: View {
   
    @ObservedObject var app: App

    var body: some View {
        
        let playPauseLabel = (app.routineModel.state == .paused || app.routineModel.state == .stopped) ? "Play" : "Pause"
        
        return HStack(alignment: .center) {
                   
            if self.app.showMainView {

                Button(action: {
                    self.app.routineModel.previous()
                }) {
                    Image(nsImage: NSImage(named: NSImage.goLeftTemplateName)! )
                }
                Button(action: {
                    self.app.routineModel.togglePause()
                }) {
                    Text(playPauseLabel)
                }
                Button(action: {
                    self.app.routineModel.next()
                }) {
                    Image(nsImage: NSImage(named: NSImage.goRightTemplateName)! )
                }
            }
            
            else {
                Button(action: {
                    self.app.persist()
                    self.app.showMainView = true
                }) {
                    Text("Save")
                }
                Button(action: {
                    self.app.showMainView = true
                }) {
                    Text("Cancel")
                }
                
            }
            
        }
    }
}
