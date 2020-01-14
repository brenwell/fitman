//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

fileprivate let flag = true

struct MyTabbedView: View {

var body: some View {
        TabView {
            HomeView().tabItem {
                VStack {
//                    Image(systemName: "1.circle")
                    Text("Home")
                }
            }.tag(1)
            AboutView().tabItem {
                VStack {
//                    Image(systemName: "2.circle")
                    Text("About")
                }
            }.tag(2)
        }
    }
}
struct AboutView: View {
var body: some View {
    ZStack {
        Color.blue
            .edgesIgnoringSafeArea(.all)
        Text("About View")
            .font(.largeTitle)
    }
}
}
struct HomeView: View {
    var body: some View {
        ZStack {
            Color.red
            .edgesIgnoringSafeArea(.all)
            Text("Home View")
                .font(.largeTitle)
        }
    }
}

struct TabbedContentView: View {


var controller: ExerciseController
let sessionLabels: [String]
var previousSelectedExerciseSet: Int = 0

@ObservedObject var state: SessionViewModel
@State var current: Int
@State var playPauseLabel: String = "Play"
@State var selectedExerciseSet = 0
@State var someNumber = "999"

var body: some View {
    
    TabView {
        RunView(state: state, playPauseLabel: playPauseLabel).tabItem {
            VStack {
                Image("1.circle")
                Text("Run")
            }
        }.tag(1)
//        DefaultsView(
//            controller: controller,
//            sessionLabels: sessionLabels,
//            selectedExerciseSet: $selectedExerciseSet,
////            preludeDelay: $someNumber
//            ).tabItem {
//                VStack {
//                    Image("2.circle")
//                    Text("Select")
//                }
//        }.tag(2)
    }
}
}
