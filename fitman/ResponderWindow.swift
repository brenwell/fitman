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
    public var model: SessionViewModel?
    // Allow view to receive keypress (remove the purr sound)
    override var acceptsFirstResponder : Bool {
        return true
    }

    // Override the NSView keydown func to read keycode of pressed key
    override func keyDown(with theEvent: NSEvent) {
        Swift.print(theEvent.keyCode)
        
        switch theEvent.keyCode {
            case 49: //space
                // TODO
                if let m = self.model {
                    m.togglePause()
                }
                return print("key space")
            case 123: //left
                // TODO
                if let m = self.model {
                    m.previous()
                }
                return print("key left")
            case 124: //right
                // TODO
                if let m = self.model {
                    m.next()
                }
                return print("key right")
            default:
                return
        }
    }
}
