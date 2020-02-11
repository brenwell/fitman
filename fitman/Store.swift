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
    
    func changeRoutineLabel(label: String) {
        updateRoutines(label: label)
    }
    
    
    func changeRoutineGap(gap: String) {
        
        guard let gapInt = Int(gap) else {
            return
        }
        
        updateRoutines(gap: gapInt)
    }
    
    func changeExerciseLabel(label: String, index: Int) {
        
        if (label == "") { return }
        
        let old = self.selectedRoutine.routine.exercises
        
        let new: Exercises = old.enumerated().map { (offset: Int, ex: Exercise) in
            let l = (ex.id == index) ? label : ex.label
            return Exercise(label: l, duration: ex.duration, enabled: ex.enabled, id: offset)
        }
        
        updateRoutines(exercises: new)
    }
    
    func changeExerciseDuration(duration: String, index: Int) {
        
        guard let durationInt = Int(duration) else {
            return
        }
        
        let old = self.selectedRoutine.routine.exercises
        
        let new: Exercises = old.enumerated().map { (offset: Int, ex: Exercise) in
            let d = (ex.id == index) ? durationInt : ex.duration
            return Exercise(label: ex.label, duration: d, enabled: ex.enabled, id: offset)
        }
        
        updateRoutines(exercises: new)

    }
    
    func changeExerciseEnabled(enabled: Bool, index: Int) {
        
        let old = self.selectedRoutine.routine.exercises
        
        let new: Exercises = old.enumerated().map { (offset: Int, ex: Exercise) in
            let e = (ex.id == index) ? enabled : ex.enabled
            return Exercise(label: ex.label, duration: ex.duration, enabled: e, id: offset)
        }
        
        updateRoutines(exercises: new)
    }
    
    func addExercise() {
        
        self.addExercise(index: self.selectedRoutine.routine.exercises.count)
    }
    
    func addExercise(index: Int) {
        
        let old = self.selectedRoutine.routine.exercises
        
        let empty = emptyExercise(idx: index)
        
        let new = insert(item: empty, arr: old, idx: index) as! Exercises
        
        let indexed = reIndexExercises(exercises: new)
        
        updateRoutines(exercises: indexed)
    }
    
    func removeExercise(index: Int) {
        
        let old = self.selectedRoutine.routine.exercises
        
        let new = remove(arr: old, idx: index) as! Exercises
        
        let indexed = reIndexExercises(exercises: new)
        
        updateRoutines(exercises: indexed)
    }

    func addRoutine() {
        
        let old = self.routines
        
        let empty = emptyRoutine(idx: old.count, gap: Int(self.settings.gap))
        
        let new = insert(item: empty, arr: old, idx: old.count) as! Routines
        
        let indexed = reIndexRoutines(routines: new)
        
        self.routines = indexed
        
        // Change to new routine
        changeSelectedRoutine(index: self.routines.count - 1 )
    }
    
    func deleteRoutine() {
        
        let new = self.routines.filter { $0.id != selectedRoutineIndex }
        
        let indexed = reIndexRoutines(routines: new)
        
        self.routines = indexed
        
        changeSelectedRoutine(index: 0)
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
        let i = id ?? self.selectedRoutine.routine.id
        let s = settings ?? self.settings
        
        let routine = Routine(label: l, gap: g, exercises: e, id: i)
        
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
    
    return [] + part1 + [item] + part2 as! Exercises
}

func remove(arr: Array<Any>, idx: Int) -> Array<Any> {
    
    let part1 = arr[0..<idx]
    let part2 = arr[idx+1..<arr.count]
        
    return [] + part1 + part2
}

func reIndexExercises(exercises: Exercises) -> Exercises {
    return exercises.enumerated().map { (offset: Int, ex: Exercise) in
        return Exercise(label: ex.label, duration: ex.duration, enabled: ex.enabled, id: offset)
    }
}

func reIndexRoutines(routines: Routines) -> Routines {
    return routines.enumerated().map { (offset: Int, ro: Routine) in
        return Routine(label: ro.label, gap: ro.gap, exercises: ro.exercises, id: offset)
    }
}

func emptyExercise(idx: Int) -> Exercise {
    return Exercise(label: "", duration: 30, enabled: true, id: idx)
}

func emptyRoutine(idx: Int, gap: Int) -> Routine {
    let ex = emptyExercise(idx: 0)
    return  Routine(label: "New Routine", gap: gap, exercises: [ex], id: idx)
}



