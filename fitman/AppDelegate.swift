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
    var exerciseController: App?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    
        self.exerciseController = App()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(app: self.exerciseController!)
        
        // Create the window and set the content view. 
        window = ResponderWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
        window.model = self.exerciseController?.routineModel
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        enableScreenSleep()
    }
}
