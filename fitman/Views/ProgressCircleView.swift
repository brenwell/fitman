//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct ProgressCircle: View {

    @ObservedObject var session: SessionViewModel
    
    var body: some View {
        
        let width: CGFloat = 20.0
        let frameWidth: CGFloat = 600.0
        
        let barColorStr = getColor(state: session.state)
        let barColor = NSColor(named: NSColor.Name(barColorStr))
        let bgColor = NSColor(named: NSColor.Name("progressBarBg"))

        return ZStack {
            Circle()
                .stroke(Color(bgColor!), lineWidth: width)
                .frame(width: frameWidth)
                .rotationEffect(Angle(degrees:-90))
            Circle()
                .trim(from: 0.0, to: CGFloat(session.elapsed / session.duration))
                .stroke(Color(barColor!), lineWidth: width)
                .frame(width: frameWidth)
                .rotationEffect(Angle(degrees:-90))
        }
    }
}


func getColor(state: SessionState) -> String {
    switch state {
    case .playing:
        return "exerciseProgressBar"
    case .paused:
        return "countInProgressBar"
    default:
        return "stoppedProgressBar"
    }
}
