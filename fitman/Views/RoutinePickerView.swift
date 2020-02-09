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
        
        let labels: [String] = store.routines.map { $0.label }
        
        return HStack() {
        
            Picker(selection: Binding(
                get: {
                    return self.store.selectedRoutineIndex
                },
                set: { (newValue) in
                    return self.store.changeSelectedRoutine(index: newValue)
                }
            )
            , label: Text("")) {
                ForEach(0 ..< labels.count, id: \.self) {
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
