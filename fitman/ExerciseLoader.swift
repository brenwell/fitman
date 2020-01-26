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
    guard let filepath = Bundle.main.path(forResource: "routines", ofType: "json") else {
        exerciseErrorDialog(text: "JSON file exercise.json not found")
        return nil
    }
    
    do {
        let contents = try String(contentsOfFile: filepath)
        print(contents)
        let data = Data(contents.utf8)
        let decoder = JSONDecoder()
        let exDb = try decoder.decode(Database.self, from: data)
        return exDb
        
    } catch {
        exerciseErrorDialog(text: "JSON read of file exercise.json failed")
        
        return nil
    }

}

//func loadOldData() -> ExerciseSessionDatabase {
//    guard let filepath = Bundle.main.path(forResource: "exercise", ofType: "json") else {
//        exerciseErrorDialog(text: "JSON file exercise.json not found")
//        return ["rob":[]]
//    }
//
//    do {
//        let contents = try String(contentsOfFile: filepath)
////            print(contents)
//        let data = Data(contents.utf8)
//        let decoder = JSONDecoder()
//        let exDb = try decoder.decode(ExerciseSessionDatabase.self, from: data)
//        return exDb
//
//    } catch {
//        exerciseErrorDialog(text: "JSON read of file exercise.json failed")
//
//        return ["rob":[]]
//    }
//
//}

//func saveData() -> Bool {
//    guard let filepath = Bundle.main.path(forResource: "exercise", ofType: "json") else {
//        exerciseErrorDialog(text: "JSON file exercise.json not found")
//        return false
//    }
//
//    do {
//
//        let json = try JSONEncoder().encode(ExerciseSessionDatabase)
//        json.wr
//        return true
//
//    } catch {
//        exerciseErrorDialog(text: "JSON read of file exercise.json failed")
//
//        return false
//    }
//
//}
