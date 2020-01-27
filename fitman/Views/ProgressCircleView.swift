//
//  ContentView.swift
//  Timed
//
//  Created by Brendon Blackwell on 08.01.20.
//  Copyright © 2020 Brendon Blackwell. All rights reserved.
//

import SwiftUI

struct ProgressCircleView: View {

    @ObservedObject var routine: RoutineModel
    
    var body: some View {
        
        let width: CGFloat = 20.0
        
        let barColorStr = getColor(state: routine.state)
        let barColor = NSColor(named: NSColor.Name(barColorStr))
        let bgColor = NSColor(named: NSColor.Name("progressBarBg"))
        
        let decimalInverted = 1 - (CGFloat(routine.elapsed / routine.duration))
        

        return ZStack {
            Circle()
                .stroke(Color(barColor!), lineWidth: width)
                
                .rotationEffect(Angle(degrees:-90))
            Circle()
                .trim(from:decimalInverted, to: 1.0)
                .stroke(Color(bgColor!), lineWidth: width)
                
                .rotationEffect(Angle(degrees:-90))
                
            }
    }
}


func getColor(state: RoutineState) -> String {
    switch state {
    case .playing:
        return "exerciseProgressBar"
    case .paused:
        return "countInProgressBar"
    default:
        return "stoppedProgressBar"
    }
}
