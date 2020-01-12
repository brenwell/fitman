//
//  AppDelegate.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/7/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Cocoa
import SwiftUI
import AVFoundation


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: ResponderWindow!
    var exerciseController: ExerciseController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        self.exerciseController = ExerciseController()
        
        // Create the SwiftUI view that provides the window contents.
        let labels: Array<String> = Array(self.exerciseController!.exLabels)
        let contentView = ContentView(
            controller: self.exerciseController!,
            sessionLabels: labels,
            state: self.exerciseController!.model,
            current: self.exerciseController!.model.currentExerciseIndex)
        
//        self.exerciseController?.model.contentView = contentView // dont thinnk I need this anymore
        
        // Create the window and set the content view. 
        window = ResponderWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        window.model = self.exerciseController?.model

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}
