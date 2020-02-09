//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI


struct ButtonControlView: View {
   
    @ObservedObject var store: Store

    var body: some View {
        
        let playPauseLabel = (store.selectedRoutine.state == .paused || store.selectedRoutine.state == .stopped) ? "Play" : "Pause"
        
        return HStack(alignment: .center) {
                   
            if self.store.showMainView {

                Button(action: {
                    self.store.selectedRoutine.previous()
                }) {
                    Image(nsImage: NSImage(named: NSImage.goLeftTemplateName)! )
                }
                Button(action: {
                    self.store.selectedRoutine.togglePause()
                }) {
                    Text(playPauseLabel)
                }
                Button(action: {
                    self.store.selectedRoutine.next()
                }) {
                    Image(nsImage: NSImage(named: NSImage.goRightTemplateName)! )
                }
            }
            
            else {
                Button(action: {
                    self.store.persist()
                    self.store.showMainView = true
                }) {
                    Text("Save")
                }
                Button(action: {
                    self.store.undo()
                    self.store.showMainView = true
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    self.store.deleteRoutine()
                }) {
                    Text("Delete")
                }
                
                Button(action: {
                    self.store.addRoutine()
                }) {
                    Text("Add New")
                }
                
            }
            
        }
    }
}
