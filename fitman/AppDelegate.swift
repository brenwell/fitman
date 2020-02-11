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

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // create a store
        let store: Store = Store()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(store: store)
        
        // Create the window and set the content view. 
        window = ResponderWindow(store: store)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        
    
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        enableScreenSleep()
    }
}
