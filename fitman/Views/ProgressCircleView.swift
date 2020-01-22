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
        
        let bgColor = NSColor(named: NSColor.Name("progressBarBg"))
        let barColor = NSColor(named: NSColor.Name("exerciseProgressBar"))
        
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

