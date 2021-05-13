//
//  StudentModel.swift
//  studentsList
//
//  Created by Луиза Розмарица on 26.04.2021.
//

import RealmSwift

class Student: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var mark: String = ""
    
    convenience init(name: String, lastName: String, mark: String) {
        self.init()
        self.name = name
        self.lastName = lastName
        self.mark = mark
    }
    
}
