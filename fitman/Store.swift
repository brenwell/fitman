//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//

import SwiftUI


class Store: ObservableObject {

    // should always represent the actual hard disk,
    // used to do undos
    var database: Database
    
    // should be the current state at all time
    // the complete opposite to the database property
    @Published var showMainView: Bool = true
    @Published var selectedRoutine: RoutineModel
    @Published var selectedRoutineIndex: Int = 0
    @Published var routines: Routines
    @Published var settings: Settings
    
    init() {
        let db: Database = loadData()!
        let settings = Settings()
        
        self.selectedRoutine = Store.createRoutineModel(routine: db.routines[db.current], settings: settings)
        self.selectedRoutineIndex = db.current
        self.routines = db.routines
        self.database = db
        self.settings = settings
    }
    
    // used to persist changes
    func persist() {
        
        // update the in memory database
        database = Database(routines: self.routines, modified: "\(Int(NSDate().timeIntervalSince1970))", current: self.selectedRoutineIndex)
        
        // and persist to disk
        let success = saveData(database: database)
        
        print("Saving changes - success: \(success)")
    }
    
    // Used to cancel changes
    func undo() {
        
        setCurrentRoutine(index: database.current, routines: database.routines, settings: self.settings)
        
        self.routines = database.routines
        
        print("Undoing changes")
    }
    
    func reset() {
        let db: Database = loadResetData()!
         
         setCurrentRoutine(index:  db.current, routines: db.routines, settings: settings)
         self.routines = db.routines
         self.database = db
    }
    
    func changeSelectedRoutine(index: Int) {
        
        self.selectedRoutine.stop()

        setCurrentRoutine(index: index, routines: self.routines, settings: self.settings)
        
        persist()
    }
    
    func addRoutine() {
        
        let old = self.routines
        
        let empty = emptyRoutine(gap: Int(self.settings.gap))
        
        self.routines = insert(item: empty, arr: old, idx: old.count) as! Routines
        
        // Change to new routine
        changeSelectedRoutine(index: self.routines.count - 1 )
    }
    
    func deleteRoutine() {
        
        self.routines = remove(arr: self.routines, idx: self.selectedRoutineIndex) as! Routines
        
        changeSelectedRoutine(index: 0)
    }
    
    func duplicateRoutine() {
        let old = self.selectedRoutine.routine
        
        let duplicateLabel = "\(old.label) Copy"
        
        let duplicate = Routine(id: UUID(), label: duplicateLabel, gap: old.gap, exercises: old.exercises)
        
        self.routines = insert(item: duplicate, arr: self.routines, idx: self.routines.count) as! Routines
        
        // Change to new routine
        changeSelectedRoutine(index: self.routines.count - 1 )
    }
    
    func changeRoutineLabel(label: String) {
        updateRoutines(label: label)
    }
    
    
    func changeRoutineGap(gap: String) {
        
        guard let gapInt = Int(gap) else {
            return
        }
        
        updateRoutines(gap: gapInt)
    }
    
    func changeExerciseLabel(label: String, id: UUID) {
        
        if (label == "") { return }
        
        let old = self.selectedRoutine.routine.exercises
        
        let new: Exercises = old.enumerated().map { (offset: Int, ex: Exercise) in
            let l = (ex.id == id) ? label : ex.label
            return Exercise(id: ex.id, label: l, duration: ex.duration, enabled: ex.enabled)
        }
        
        updateRoutines(exercises: new)
    }
    
    func changeExerciseDuration(duration: String, id: UUID) {
        
        guard let durationInt = Int(duration) else {
            return
        }
        
        let old = self.selectedRoutine.routine.exercises
        
        let new: Exercises = old.enumerated().map { (offset: Int, ex: Exercise) in
            let d = (ex.id == id) ? durationInt : ex.duration
            return Exercise(id: ex.id, label: ex.label, duration: d, enabled: ex.enabled)
        }
        
        updateRoutines(exercises: new)

    }
    
    func changeExerciseEnabled(enabled: Bool, id: UUID) {
        
        let old = self.selectedRoutine.routine.exercises
        
        let new: Exercises = old.enumerated().map { (offset: Int, ex: Exercise) in
            let e = (ex.id == id) ? enabled : ex.enabled
            return Exercise(id: ex.id, label: ex.label, duration: ex.duration, enabled: e)
        }
        
        updateRoutines(exercises: new)
    }
    
    func addExercise() {
        
        let old = self.selectedRoutine.routine.exercises
        
        let empty = emptyExercise()
        
        let index = old.count - 1
        
        let new = insert(item: empty, arr: old, idx: index) as! Exercises
        
        updateRoutines(exercises: new)
    }
    
    func addExercise(before: UUID) {
        
        let old = self.selectedRoutine.routine.exercises
        
        let empty = emptyExercise()
        
        let index = old.firstIndex{$0.id == before} ?? old.count - 1
        
        let new = insert(item: empty, arr: old, idx: index) as! Exercises
        
        updateRoutines(exercises: new)
    }
    
    func removeExercise(id: UUID) {
        
        let old = self.selectedRoutine.routine.exercises
        
        let new = old.filter { $0.id != id }
        
        updateRoutines(exercises: new)
    }

    
    /**
            Private Methods (Helpers)
     */
    
    private func updateRoutines(label: String) {
        updateRoutines(label: label, gap: nil, exercises: nil, id: nil, settings: nil)
    }
    
    private func updateRoutines(gap: Int) {
        updateRoutines(label: nil, gap: gap, exercises: nil, id: nil, settings: nil)
    }
    
    private func updateRoutines(exercises: Exercises) {
        updateRoutines(label: nil, gap: nil, exercises: exercises, id: nil, settings: nil)
    }

    private func updateRoutines(label: String?, gap: Int?, exercises: Exercises?, id: Int?, settings: Settings?) {
        
        let l = label ?? self.selectedRoutine.routine.label
        let g = gap ?? self.selectedRoutine.routine.gap
        let e = exercises ?? self.selectedRoutine.routine.exercises
        let s = settings ?? self.settings
        
        let routine = Routine(id: self.selectedRoutine.routine.id, label: l, gap: g, exercises: e)
        
        self.selectedRoutine = Store.createRoutineModel(routine: routine, settings: s)
        
        self.routines = self.routines.map { (po: Routine) in
            if po.id != self.selectedRoutine.routine.id {
                return po
            }
            return self.selectedRoutine.routine
        }
    }
    
    private func setCurrentRoutine(index: Int, routines: Routines, settings: Settings) {
        
        let routine: Routine = routines[index]
        
        (self.selectedRoutine, self.selectedRoutineIndex) = (Store.createRoutineModel(routine: routine, settings: settings), index)
    }


    private static func createRoutineModel(routine: Routine, settings: Settings ) -> RoutineModel {

        let speaker = Speaker(voice: settings.voice, locale: settings.locale, rate: settings.rate)
        
        return RoutineModel(routine: routine, speaker: speaker, frequency: settings.frequency, announcementInterval: settings.announceInterval)
    }

}


func insert(item: Any, arr: Array<Any>, idx: Int) -> Array<Any> {
    
    let part1 = arr[0..<idx]
    let part2 = arr[idx..<arr.count]
    
    return [] + part1 + [item] + part2
}

func remove(arr: Array<Any>, idx: Int) -> Array<Any> {
    
    let part1 = arr[0..<idx]
    let part2 = arr[idx+1..<arr.count]
        
    return [] + part1 + part2
}


func emptyExercise() -> Exercise {
    return Exercise(id: UUID(), label: "", duration: 30, enabled: true)
}

func emptyRoutine(gap: Int) -> Routine {
    let ex = emptyExercise()
    return  Routine(id: UUID(), label: "New Routine", gap: gap, exercises: [ex])
}



