//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

// Structire the app as a single view
struct ContentView: View {
    
    @ObservedObject var store: Store
    
    var body: some View {

        return VStack(alignment: HorizontalAlignment.center)
        {
            TopView(store: store)
            MainContentView(store: store)
            BottomView(store: store)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        let store = Store()
        
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(store: store)
        
        return contentView
    }
}

