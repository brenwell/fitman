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

let R_INDEX_KEY: String = "routineIndex"
let R_LABEL_KEY: String = "routineLabel"

class Store: ObservableObject {

    var database: Database
    @Published var showMainView: Bool = true
    @Published var selectedRoutine: RoutineModel
    @Published var selectedRoutineIndex: Int = 0
    @Published var routines: Routines
    
    init() {
        let db: Database = loadData()!
        let index = Store.getCurrentRoutineIndex(routines: db.routines)
        
        self.database = db
        self.selectedRoutine = Store.setCurrentRoutine(index: index, routines: db.routines)
        self.selectedRoutineIndex = index
        self.routines = database.routines
    }
    
    // used to persist changes
    func persist() {
        
        var db = self.database
        db.routines = self.routines
        db.modified = "\(Int(NSDate().timeIntervalSince1970))"
        
        self.database = db
        let success = saveData(database: db)
        
        print("Saving changes - success: \(success)")
    }
    
    // Used to cancel changes
    func undo() {
        let db = self.database
        let index = Store.getCurrentRoutineIndex(routines: db.routines)
        
        self.database = db
        self.selectedRoutine = Store.setCurrentRoutine(index: index, routines: db.routines)
        self.selectedRoutineIndex = index
        self.routines = database.routines
        
        print("Undoing changes")
    }
    
    func changeSelectedRoutine(index: Int) {
        
        self.selectedRoutineIndex = index
        
        self.selectedRoutine.stop(playNoise: false)

        self.selectedRoutine = Store.setCurrentRoutine(index: selectedRoutineIndex, routines: self.routines)
        
        Store.saveCurrentRoutineIndex(index: self.selectedRoutineIndex, label: self.selectedRoutine.routine.label)
    }
    
    func changeRoutineLabel(label: String) {
        let old = self.selectedRoutine.routine
        
        self.selectedRoutine = Store.createRoutineModel(label: label, gap: old.gap, exercises: old.exercises, id: old.id)
        
        self.routines = self.routines.map { (po: Routine) in
            if po.id != old.id {
                return po
            }
            return self.selectedRoutine.routine
        }
    }
    
    func changeExerciseLabel(label: String, index: Int) {
        
        if (label == "") { return }
        
        var old = self.selectedRoutine.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: label, duration: oldEx.duration, enabled: oldEx.enabled, id: oldEx.id)
        
        self.selectedRoutine = Store.createRoutineModel(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
    }
    
    func changeExerciseDuration(duration: String, index: Int) {
        
        guard let durationInt =  Int(duration) else {
            return
        }
        
        var old = self.selectedRoutine.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: oldEx.label, duration: durationInt, enabled: oldEx.enabled, id: oldEx.id)
        
        self.selectedRoutine = Store.createRoutineModel(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
    }
    
    func changeExerciseEnabled(enabled: Bool, index: Int) {
        
        var old = self.selectedRoutine.routine
        let oldEx = old.exercises[index]
        old.exercises[index] = Exercise(label: oldEx.label, duration: oldEx.duration, enabled: enabled, id: oldEx.id)
        
        self.selectedRoutine = Store.createRoutineModel(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
    }
    
    func addExercise() {
        
        var old = self.selectedRoutine.routine
        
        let emptyEx = Exercise(label: "", duration: 30, enabled: true, id: old.exercises.count)
        
        old.exercises.append(emptyEx)
        
        self.selectedRoutine = Store.createRoutineModel(label: old.label, gap: old.gap, exercises: old.exercises, id: old.id)
    }
    
    func removeExercise(index: Int) {
        let old = self.selectedRoutine.routine
        let oldEx = old.exercises.filter { $0.id != index }
        
        self.selectedRoutine = Store.createRoutineModel(label: old.label, gap: old.gap, exercises: oldEx, id: old.id)
    }

    func addRoutine() {
        var old = self.routines
        
        let emptyRo = Routine(label: "New Routine", gap: Int(Settings.gap), exercises: [], id: old.count)
        
        old.append(emptyRo)
        
        self.routines = old
        
        changeSelectedRoutine(index: self.routines.count - 1 )
        
        addExercise()
    }
    
    func deleteRoutine() {
        self.routines = database.routines.filter { $0.id != selectedRoutineIndex }
        
        changeSelectedRoutine(index: 0)
    }
    
    /**
            Private Static Methods (Helpers)
     */

    private static func setCurrentRoutine(index: Int, routines: Routines) -> RoutineModel {
        
        let routine: Routine = routines[index]
        
        return createRoutineModel(routine: routine)
    }

    private static func createRoutineModel(label: String, gap: Int, exercises: Exercises, id: Int ) -> RoutineModel {
        
        let routine = Routine(label: label, gap: gap, exercises: exercises, id: id)
        
        return createRoutineModel(routine: routine)
    }

    private static func createRoutineModel(routine: Routine ) -> RoutineModel {

        let speaker = Speaker(voice: Settings.voice, locale: Settings.locale, rate: Settings.rate)
        
        return RoutineModel(routine: routine, speaker: speaker)
    }


    private static func getCurrentRoutineIndex(routines: Routines) -> Int {
        
        var index: Int = UserDefaults.standard.integer(forKey: R_INDEX_KEY)
        
        if (index < 0 || index >= routines.count) {
            index = 0
        }
        
        return index
    }

    private static func saveCurrentRoutineIndex(index: Int, label: String) {
        
        UserDefaults.standard.set(index, forKey: R_INDEX_KEY)
        UserDefaults.standard.set(label, forKey: R_LABEL_KEY)
    }
}


