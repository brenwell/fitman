//
//  Controller.swift
//  fitman
//
//  Created by Robert BLACKWELL on 1/8/20.
//  Copyright © 2020 Robert Blackwell. All rights reserved.
//
// Functions for loading a simple database of exercise sessions
//
//
import Cocoa
import SwiftUI
import Foundation
import AVFoundation



func loadData() -> Database? {
    
    do {
        let savedPath = getPersonalDataPath()
        
        if let database = attemptToLoadFile(path: savedPath) {
            print("got from saved")
            print(database)
            return database
        }
    }

    print("not got from saved")
    
    guard let bundlePath = Bundle.main.path(forResource: "routines", ofType: "json") else {
        exerciseErrorDialog(text: "JSON file exercise.json not found")
        return nil
    }

    if let database = attemptToLoadFile(path: bundlePath) {
        print(database)
        return database
    }

    return nil
    
}

func saveData(database: Database) -> Bool {
//    let filepath = Bundle.main.path(forResource: "test", ofType: "json")!
    
    let persistedDb = parseAppDataToPersist(db: database)
    let path = getPersonalDataPath()
    let url: URL = URL(fileURLWithPath: path)
    
    if let encodedData =  try? JSONEncoder().encode(persistedDb) {
        
        do {
            try encodedData.write(to: url)
            return true
        }
        catch {
            print("Failed to write JSON data: \(error.localizedDescription)")
        }
        return false
    }

    return false
}

func attemptToLoadFile(path: String) -> Database? {
    do {
        let contents = try String(contentsOfFile: path)
        let data = Data(contents.utf8)
        let persisted = try JSONDecoder().decode(PersistedDatabase.self, from: data)
        let db = parsePersistedDataToApp(persisted: persisted)
        return db
        
    } catch {
//        exerciseErrorDialog(text: "JSON read of file exercise.json failed")
        
        return nil
    }
}

func parsePersistedDataToApp(persisted: PersistedDatabase) -> Database {
    
    let persistedRoutines: PersistedRoutines = persisted.routines
    
    let routines: Routines = persistedRoutines.enumerated().map { (offset: Int, ro: PersistedRoutine) in
        
        let exercises: Exercises = ro.exercises.enumerated().map { (offset: Int, ex: PersistedExercise) in
            return Exercise(label: ex.label, duration: ex.duration, enabled: ex.enabled, id: offset)
        }
        
        return Routine(label: ro.label, gap: ro.gap, exercises: exercises, id: offset)
    }
    
    let db = Database(routines: routines, modified: persisted.modified)
    
    return db
}

func parseAppDataToPersist(db: Database) -> PersistedDatabase {
    
    let routines: Routines = db.routines
    
    let persistedRoutines: PersistedRoutines = routines.enumerated().map { (offset: Int, po: Routine) in
        
        let persistedExercises: PersistedExercises = po.exercises.enumerated().map { (offset: Int, ex: Exercise) in
            return PersistedExercise(label: ex.label, duration: ex.duration, enabled: ex.enabled)
        }
        
        return PersistedRoutine(label: po.label, gap: po.gap, exercises: persistedExercises)

    }
    
    let persistedDb = PersistedDatabase(routines: persistedRoutines, modified: db.modified)
    
    return persistedDb
}


func getPersonalDataPath() -> String {
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let path = documents.appending("/database.json")
    return path
}
