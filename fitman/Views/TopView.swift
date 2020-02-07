//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct TopView: View {
    
    @ObservedObject var store: Store

    var body: some View {

        return HStack(alignment: .center, spacing: 20)
        {
            RoutinePickerView(store: store)
            
            Spacer()
            
            ButtonControlView(store: self.store)
        
        }.padding(10)

    }
}
