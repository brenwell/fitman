//
//  ResponderWindow.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/9/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import Cocoa

// We subclass an NSView

class ResponderWindow: NSWindow {
    public var store: Store
    
    init(store: Store) {
        
        self.store = store
        
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
    }
    
    // Allow view to receive keypress (remove the purr sound)
    override var acceptsFirstResponder : Bool {
        return true
    }

    // Override the NSView keydown func to read keycode of pressed key
    override func keyDown(with theEvent: NSEvent) {
        
        switch theEvent.keyCode {
            case 49: //space
                
                
                store.selectedRoutine.togglePause()
                
                return //print("key space")
            case 123: //left
                
                
                store.selectedRoutine.previous()
                
                return //print("key left")
            case 124: //right
                
                
                store.selectedRoutine.next()
                
                return //print("key right")
            default:
                return
        }
    }
}
