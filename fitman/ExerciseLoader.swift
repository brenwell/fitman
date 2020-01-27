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
    
    let path = getPersonalDataPath()
    let url: URL = URL(fileURLWithPath: path)
    
    if let encodedData =  try? JSONEncoder().encode(database) {
        
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
        let db = try JSONDecoder().decode(Database.self, from: data)
        return db
        
    } catch {
//        exerciseErrorDialog(text: "JSON read of file exercise.json failed")
        
        return nil
    }
}


func getPersonalDataPath() -> String {
    let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let path = documents.appending("/database.json")
    return path
}
