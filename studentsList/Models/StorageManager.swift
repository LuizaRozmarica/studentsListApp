//
//  StorageManager.swift
//  studentsList
//
//  Created by Луиза Розмарица on 01.05.2021.
//

import RealmSwift

let realm = Realm.safeInit()

class StorageManager {
    
    static func saveObject(_ student: Student) {
        
        do {
            try realm?.write {
                realm?.add(student)
            }
        } catch {
            print("Failed to save")
        }
    }
    
    static func deleteObject(_ student: Student) {
        
        do {
            try realm?.write {
                realm?.delete(student)
            }
        } catch {
            print("Failed to delete")
            
        }
}

extension Realm {
    static func safeInit() -> Realm? {
        do {
            let realm = try Realm()
            return realm
        }
        catch {
            print("Failed to init Realm object")
        }
        return nil
    }
}
