//
//  StorageManager.swift
//  studentsList
//
//  Created by Луиза Розмарица on 01.05.2021.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ student: Student) {
        
        try! realm.write {
            realm.add(student)
        }
    }
    
    static func deleteObject(_ student: Student) {
        
        try! realm.write {
            realm.delete(student)
        }
    }
}
