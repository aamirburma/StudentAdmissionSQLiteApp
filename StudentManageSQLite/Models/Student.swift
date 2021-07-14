//
//  Student.swift
//  StudentManageSQLite
//
//  Created by Aamir Burma on 14/07/21.
//

import Foundation

class Student {
    var id:Int = 0
    var name:String = ""
    var age:Int = 0
    var spid:Int = 0
    
    init(id:Int, name:String, age:Int, spid:Int) {
        self.id = id
        self.name = name
        self.age = age
        self.spid = spid
    }
}
