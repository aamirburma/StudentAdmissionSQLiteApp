//
//  File.swift
//  StudentManageSQLite
//
//  Created by Aamir Burma on 14/07/21.
//

import Foundation
import SQLite3

class SQLiteHandler {
    
    static let shared = SQLiteHandler()
    
    let dbPath = "studDB.sqlite"
    var db:OpaquePointer?
    
    /** Call Constructor */
    private init(){
        db = openDatabase()
        createTable()
    }
    
    /** Open database and DB connections */
    func openDatabase() -> OpaquePointer? {
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docURL.appendingPathComponent(dbPath)
        
        var database:OpaquePointer? = nil
        
        if sqlite3_open(fileURL.path, &database) == SQLITE_OK {
            print("Opened connection to the database successfully at : \(fileURL)")
            return database
        }
        else {
            print("Error in connection of Database")
            return nil
        }
    }
    
    /** Create Table if not exist */
    func createTable(){
        
        let createTableString1 = """
        CREATE TABLE IF NOT EXISTS stud(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        age INTEGER,
        spid INTEGER
        );
        """
        
        let createTableString2 = """
        CREATE TABLE IF NOT EXISTS notice(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        note TEXT
        );
        """
        
        var createTableStatement:OpaquePointer? = nil
        
        var createTableStatement2:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, createTableString1, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_OK {
                print("stud table is created successfully")
            }
            else{
                print("stud table statement is not prepared")
            }
        }
        else{
            print("CREATE TABLE STATEMENT of stud is not prepared")
        }
        
        if sqlite3_prepare_v2(db, createTableString2, -1, &createTableStatement2, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement2) == SQLITE_OK {
                print("notice table is created successfully")
            }
            else{
                print("notice table statement is not prepared")
            }
        }
        else{
            print("CREATE TABLE STATEMENT of notice is not prepared")
        }
        
        // Delete Statements
        
        sqlite3_finalize(createTableStatement)
        sqlite3_finalize(createTableStatement2)
    }
    
    /** Insert Statement of stud table*/
    func insertStud(stud:Student, complition:@escaping((Bool) -> Void)){
        let insertStatementString = "INSERT INTO stud (name, age, spid) VALUES (?, ?, ?);"
        var inserStatement:OpaquePointer? = nil
        
        //Prepare statement
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &inserStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(inserStatement, 1, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(inserStatement, 2, Int32(stud.age))
            sqlite3_bind_int(inserStatement, 3, Int32(stud.spid))
        
            //Evaluate Statement
            if sqlite3_step(inserStatement) == SQLITE_DONE {
                print("Insert row in stud table successfully")
                complition(true)
            }
            else {
                print("Could not insert row in stud Table")
                complition(false)
            }
        }
        else{
            print("Insert Statemnt could not be PREPARED on stud table")
            complition(false)
        }
    }
    
    /** Insert Statement of notice table*/
    func insertNotice(note:String,complition:@escaping((Bool) -> Void)){
        let insertStatementString = "INSERT INTO notice (note) VALUES (?);"
        var inserStatement:OpaquePointer? = nil
        
        //Prepare statement
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &inserStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(inserStatement, 1, (note as NSString).utf8String, -1, nil)
        
            //Evaluate Statement
            if sqlite3_step(inserStatement) == SQLITE_DONE {
                print("Insert row in notice table successfully")
                complition(true)
            }
            else {
                print("Could not insert row in notice Table")
                complition(false)
            }
        }
        else{
            print("Insert Statemnt could not be PREPARED on notice table")
            complition(false)
        }
    }
    
    /** Update statement of stud Table */
    func updateStud(stud:Student,complition:@escaping((Bool) -> Void)){
        let updateStatementString = "UPDATE stud SET name = ? , age = ? , spid = ? WHERE id = ?;"
        var updateStatement:OpaquePointer? = nil
        //Prepare statement
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (stud.name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(stud.age))
            sqlite3_bind_int(updateStatement, 3, Int32(stud.spid))
            sqlite3_bind_int(updateStatement, 4, Int32(stud.id))
        
            //Evaluate Statement
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Update row in stud table successfully")
                complition(true)
            }
            else {
                print("Could not Update row in stud Table")
                complition(false)
            }
        }
        else{
            print("Update Statemnt could not be PREPARED on stud table")
            complition(false)
        }
    }
    
    /** Update statement of notice Table */
    func updateNotice(note:Notice,complition:@escaping((Bool) -> Void)){
        let updateStatementString = "UPDATE notice SET note = ? WHERE id = ?;"
        var updateStatement:OpaquePointer? = nil
        
        //Prepare statement
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (note.note as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(note.id))
        
            //Evaluate Statement
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Update row in notice table successfully")
                complition(true)
            }
            else {
                print("Could not Update row in notice Table")
                complition(false)
            }
        }
        else{
            print("Update Statemnt could not be PREPARED on notice table")
            complition(false)
        }
    }
    
    /** Fetch Data of stud table*/
    func fetchStud() -> [Student] {
        let fetchStatementString = "SELECT * FROM stud;"
        var fetchStatement:OpaquePointer? = nil
    
        var stud = [Student]()
        
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK {
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let age = Int(sqlite3_column_int(fetchStatement, 2))
                let spid = Int(sqlite3_column_int(fetchStatement, 3))
                
                stud.append(Student(id:id, name:name, age:age, spid:spid))
                print("Query Result:")
                print("\(id) | \(name) | \(age) | \(spid)")
            }
        }
        else{
            print("SELECT Statemnt could not be PREPARED on stud table")
        }
        sqlite3_finalize(fetchStatement)
        return stud
    }
    
    /** Fetch Single Data of stud table*/
    func fetchSingleStud(studId:Int) -> [Student] {
        let fetchStatementString = "SELECT * FROM stud WHERE spid = ?;"
        var fetchStatement:OpaquePointer? = nil
    
        var stud = [Student]()
        
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(fetchStatement, 1, Int32(studId))
        
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let name = String(cString: sqlite3_column_text(fetchStatement, 1))
                let age = Int(sqlite3_column_int(fetchStatement, 2))
                let spid = Int(sqlite3_column_int(fetchStatement, 3))
                
                stud.append(Student(id:id, name:name, age:age, spid:spid))
                print("Query Result:")
                print("\(id) | \(name) | \(age) | \(spid)")
            }
        }
        else{
            print("SELECT Statemnt could not be PREPARED on stud table")
        }
        sqlite3_finalize(fetchStatement)
        return stud
    }
    
    /** Fetch Data of notice table*/
    func fetchNotice() -> [Notice] {
        let fetchStatementString = "SELECT * FROM notice;"
        var fetchStatement:OpaquePointer? = nil
    
        var notes = [Notice]()
        
        if sqlite3_prepare_v2(db, fetchStatementString, -1, &fetchStatement, nil) == SQLITE_OK {
            while sqlite3_step(fetchStatement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(fetchStatement, 0))
                let note = String(cString: sqlite3_column_text(fetchStatement, 1))
                
                notes.append(Notice(id:id, note:note))
                print("Query Result:")
                print("\(id) | \(note)")
            }
        }
        else{
            print("SELECT Statemnt could not be PREPARED on notice table")
        }
        sqlite3_finalize(fetchStatement)
        return notes
    }
    
    /** Delete stud data*/
    func deleteStud(for id:Int,complition:@escaping((Bool) -> Void)){
        
        let deleteStatementString = "DELETE FROM stud WHERE id = ?;"
        var deleteStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 0, Int32(id))
        
            //Evaluate Statement
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Delete row in stud table successfully")
                complition(true)
            }
            else {
                print("Could not Delete row in stud Table")
                complition(false)
            }
        }
        else{
            print("Delete Statemnt could not be PREPARED on stud table")
            complition(false)
        }
        sqlite3_finalize(deleteStatement)
    }
    
    /** Delete notice data*/
    func deleteNotice(for id:Int,complition:@escaping((Bool) -> Void)){
        
        let deleteStatementString = "DELETE FROM notice WHERE id = ?;"
        var deleteStatement:OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 0, Int32(id))
        
            //Evaluate Statement
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Delete row in notice table successfully")
                complition(true)
            }
            else {
                print("Could not Delete row in notice Table")
                complition(false)
            }
        }
        else{
            print("Delete Statemnt could not be PREPARED on notice table")
            complition(false)
        }
        sqlite3_finalize(deleteStatement)
    }
}
