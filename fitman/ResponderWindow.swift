import Cocoa

// We subclass an NSView

class ResponderWindow: NSWindow {

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
                return print("key space")
            case 123: //left
                // TODO
                return print("key left")
            case 124: //right
                // TODO
                return print("key right")
            default:
                return
        }
    }
}
