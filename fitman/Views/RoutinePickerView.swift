//
//  RoutinePicker.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct RoutinePickerView: View {

    @ObservedObject var store: Store

    var body: some View {
        
        let labels: [String] = store.database.routines.map { $0.label }
        
        return HStack() {
        
            Picker(selection: $store.selectedRoutineIndex, label: Text("")) {
                ForEach(0 ..< labels.count) {
                   Text(labels[$0]).tag($0)
                }
            }.frame(maxWidth: 200.0)
            
            Button(action: {
                self.store.showMainView = !self.store.showMainView
            }) {
                Image(nsImage: NSImage(named: NSImage.actionTemplateName)! )
            }
        }
    }
}
