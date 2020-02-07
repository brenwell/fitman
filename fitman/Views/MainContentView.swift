//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var store: Store

    @ViewBuilder
    var body: some View {
        if (self.store.showMainView) {
            MainView(store: store)
        } else {
            EditView(store: store)
        }
    }

}
