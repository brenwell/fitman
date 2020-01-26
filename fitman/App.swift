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

class App: ObservableObject {

    var database: Database
    
    @Published var routineModel: RoutineModel

    var selectedSessionIndex: Int = 0 {
        didSet {
            // this code is called when the view selects a new session index
            print("ExerciseController::selectedSessionIndex didSet \(self.selectedSessionIndex)")

            self.routineModel = setCurrentRoutine(index: selectedSessionIndex, database: self.database)
            
            self.routineModel.stop(playNoise: false)
                
            UserDefaults.standard.set(self.selectedSessionIndex, forKey: "routineIndex")
            UserDefaults.standard.set(self.routineModel.routine.label, forKey: "routineLabel")
        }
    }
    
    
    init() {
        let db: Database = loadData()!
        
        self.database = db

        var index: Int = UserDefaults.standard.integer(forKey: "routineIndex")
        let label: String = UserDefaults.standard.string(forKey: "routineLabel") ?? "Somethinf went wrong"
        
        print(label)
        
        if (index < 0 || index >= db.routines.count) {
            index = 0
        }
        
        self.routineModel = setCurrentRoutine(index: index, database: db)
        
        self.selectedSessionIndex = index
    }
    
}

func setCurrentRoutine(index: Int, database: Database) -> RoutineModel {
    let routines:Routines = database.routines
    let routine: Routine = routines[index]
    return RoutineModel(routine: routine)
}

