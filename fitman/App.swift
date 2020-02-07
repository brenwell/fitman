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
            print("App::selectedSessionIndex didSet \(self.selectedSessionIndex)")

            self.routineModel = setCurrentRoutine(index: selectedSessionIndex, database: self.database)
            
            self.routineModel.stop(playNoise: false)
                
            UserDefaults.standard.set(self.selectedSessionIndex, forKey: "routineIndex")
            UserDefaults.standard.set(self.routineModel.routine.label, forKey: "routineLabel")
        }
    }
    
    @Published var showMainView: Bool = true {
        didSet {
             print("App::showMainView didSet \(self.showMainView)")
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
        
//        saveData(database: db)
    }
    
    func changeExerciseLabel(label: String, index: Int) {
        
        if (label == "") { return }
        
        var old = self.routineModel.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: label, duration: oldEx.duration, enabled: oldEx.enabled, id: oldEx.id)
        let routine = Routine(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
        
        self.routineModel = RoutineModel(routine: routine)
    }
    
    func changeExerciseDuration(duration: String, index: Int) {
        
        guard let durationInt =  Int(duration) else {
            return
        }
        
        var old = self.routineModel.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: oldEx.label, duration: durationInt, enabled: oldEx.enabled, id: oldEx.id)
        let routine = Routine(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
        
        self.routineModel = RoutineModel(routine: routine)
    }
    
    
    func persist() {
        
        var db = self.database
        db.routines[self.selectedSessionIndex] = self.routineModel.routine
        
        let success = saveData(database: db)
        
        print("Saving changes - success: \(success)")
    }
    
    // Used to cancel cahnges
    func undo() {
        self.routineModel = setCurrentRoutine(index: self.selectedSessionIndex, database: self.database)
        
        print("UNdoing changes")
    }
}

func setCurrentRoutine(index: Int, database: Database) -> RoutineModel {
    let routines:Routines = database.routines
    let routine: Routine = routines[index]
    
    calculateTotalDuration(exercises: routine.exercises)
    
    return RoutineModel(routine: routine)
}

func calculateTotalDuration(exercises: Exercises) {
    let sum = exercises.reduce(0) { $0 + $1.duration }
    
    print(sum)
    

    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .full

    let formattedString = formatter.string(from: TimeInterval(sum))!
    print(formattedString)
}

