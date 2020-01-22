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
    // a convenience property holding the names of the available exercise sessions
    let exLabels: [String]

    var sessionDb: ExerciseSessionDatabase
    var model: SessionViewModel

    var selectedSessionIndex: Int = 0 {
        didSet {
            // this code is called when the view selects a new session index
            print("ExerciseController::selectedSessionIndex didSet \(self.selectedSessionIndex)")
            self.selectedSessionKey = self.exLabels[self.selectedSessionIndex]
        }
    }
    var selectedSessionKey: String {
        didSet {
            print("ExerciseController::selectSessionKey didSet \(self.selectedSessionKey)")
            UserDefaults.standard.set(self.selectedSessionKey, forKey: UserDefaultKeys.sessionKey)
            let ex: ExerciseSession = self.sessionDb[self.selectedSessionKey]!
            self.model = SessionViewModel(exercises: ex)
        }
    }
    
    
    init() {
        let sDb: ExerciseSessionDatabase = loadExerciseFile();
        self.sessionDb = sDb
        self.exLabels = sDb.map{$0.key}
        if let tmpKey: String = UserDefaults.standard.object(forKey: UserDefaultKeys.sessionKey) as? String {
            self.selectedSessionKey = tmpKey
            if let ix = self.exLabels.firstIndex(of: tmpKey) {
                self.selectedSessionIndex = ix
            } else {
                print ("Bad key in UserDefaults")
                self.selectedSessionIndex = 0
                self.selectedSessionKey = self.exLabels[0]
            }
        } else {
            self.selectedSessionKey = self.exLabels[0]
            self.selectedSessionIndex = 0
        }
        

        let ex: ExerciseSession = sDb[self.selectedSessionKey]!
        self.model = SessionViewModel(exercises: ex)
    }
}

