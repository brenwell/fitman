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

class Store: ObservableObject {

    var database: Database
    
    @Published var showMainView: Bool = true
    @Published var selectedRoutine: RoutineModel

    @Published var selectedRoutineIndex: Int = 0 {
        didSet {
            // this code is called when the view selects a new session index
            print("App::selectedSessionIndex didSet \(self.selectedRoutineIndex)")

            self.selectedRoutine = setCurrentRoutine(index: selectedRoutineIndex, database: self.database)
            
            self.selectedRoutine.stop(playNoise: false)
                
            UserDefaults.standard.set(self.selectedRoutineIndex, forKey: "routineIndex")
            UserDefaults.standard.set(self.selectedRoutine.routine.label, forKey: "routineLabel")
        }
    }
    
    
    init() {
        let db: Database = loadData()!
        let index = getCurrentRoutineIndex(db: db)
        
        self.database = db
        self.selectedRoutine = setCurrentRoutine(index: index, database: db)
        self.selectedRoutineIndex = index
    }
    
    func changeExerciseLabel(label: String, index: Int) {
        
        if (label == "") { return }
        
        var old = self.selectedRoutine.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: label, duration: oldEx.duration, enabled: oldEx.enabled, id: oldEx.id)
        let routine = Routine(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
        
        self.selectedRoutine = RoutineModel(routine: routine)
    }
    
    func changeExerciseDuration(duration: String, index: Int) {
        
        guard let durationInt =  Int(duration) else {
            return
        }
        
        var old = self.selectedRoutine.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: oldEx.label, duration: durationInt, enabled: oldEx.enabled, id: oldEx.id)
        let routine = Routine(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
        
        self.selectedRoutine = RoutineModel(routine: routine)
    }
    
    func changeExerciseEnabled(enabled: Bool, index: Int) {
        
        var old = self.selectedRoutine.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: oldEx.label, duration: oldEx.duration, enabled: enabled, id: oldEx.id)
        let routine = Routine(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
        
        self.selectedRoutine = RoutineModel(routine: routine)
    }
    
    // used to persist changes
    func persist() {
        
        var db = self.database
        db.routines[self.selectedRoutineIndex] = self.selectedRoutine.routine
        db.modified = "\(Int(NSDate().timeIntervalSince1970))"
        
        let success = saveData(database: db)
        
        print("Saving changes - success: \(success)")
    }
    
    // Used to cancel cahnges
    func undo() {
        self.selectedRoutine = setCurrentRoutine(index: self.selectedRoutineIndex, database: self.database)
        
        print("UNdoing changes")
    }
}

func setCurrentRoutine(index: Int, database: Database) -> RoutineModel {
    let routines:Routines = database.routines
    let routine: Routine = routines[index]
        
    return RoutineModel(routine: routine)
}


func getCurrentRoutineIndex(db: Database) -> Int {
    
    var index: Int = UserDefaults.standard.integer(forKey: "routineIndex")
    
    if (index < 0 || index >= db.routines.count) {
        index = 0
    }
    
    return index
}
