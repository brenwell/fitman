//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
import Cocoa
import SwiftUI
import Foundation
import AVFoundation

class ExerciseController: ObservableObject {
    let exLabels: [String]
    let model: SessionViewModel
    var selectedSessionIndex: Int = 0
    var previousSessionIndex: Int = 0

    @Published var sessionDb: ExerciseSessionDatabase
    
    init() {
        let sDb: ExerciseSessionDatabase = loadExerciseFile();
        self.selectedSessionIndex = 0
        self.sessionDb = sDb

        self.exLabels = sDb.map{$0.key}
        let k: String = self.exLabels[0]
        let ex: ExerciseSession = sDb[k]!
        self.model = SessionViewModel(exercises: ex)
    }
    func changeSession(value: Int) {
        print("ExercizeController::changeSession \(value)")
        if (self.selectedSessionIndex == value) {
            return
        }
        self.selectedSessionIndex = value
        let k: String = self.exLabels[self.selectedSessionIndex]
        print("ExercizeController::changeSession \(k)")
        let ex: ExerciseSession = self.sessionDb[k]!
        self.selectedSessionIndex = value
        self.model.changeSession(exercises: ex)
    }
}

