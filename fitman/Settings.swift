import SwiftUI

/**
  Speech methods
 */
class MyToolBar: NSToolbar, NSToolbarDelegate {

    func setup() {
        self.displayMode = .iconOnly
        self.delegate = self
        
        
        
        
        self.insertItem(withItemIdentifier: NSToolbarItem.Identifier.cloudSharing, at: 0)
    }
}


