//
//  WiDService.swift
//  WiD
//
//  Created by jjkim on 2023/07/07.
//

import Foundation
import SQLite3

class WiDService {
    private var db: OpaquePointer?
    private let dbName = "widDB.sqlite"
    
    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Unable to open database.")
            return
        }
        
        // WiD 테이블 생성
        let createWiDTableQuery = "CREATE TABLE IF NOT EXISTS WiD (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, detail TEXT, date TEXT, start TEXT, finish TEXT, duration REAL)"
        
        if sqlite3_exec(db, createWiDTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Unable to create WiD table: \(errmsg)")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    func insertWiD(wid: WiD) {
        let insertWiDQuery = "INSERT INTO WiD (title, detail, date, start, finish, duration) VALUES (?, ?, ?, ?, ?, ?)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: wid.date)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let startTimeString = timeFormatter.string(from: wid.start)
        let finishTimeString = timeFormatter.string(from: wid.finish)
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertWiDQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (wid.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (wid.detail as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (startTimeString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (finishTimeString as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 6, wid.duration)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Failed to insert WiD.")
            } else {
                print("Success to insert WiD.")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    func selectWiDByID(id: Int) -> WiD? {
        let selectWiDByIDQuery = "SELECT id, title, detail, date, start, finish, duration FROM WiD WHERE id = ?"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDByIDQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let title = String(cString: sqlite3_column_text(statement, 1))
                let detail = String(cString: sqlite3_column_text(statement, 2))
                
                let dateString = String(cString: sqlite3_column_text(statement, 3))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateString)!
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finishTimeString = String(cString: sqlite3_column_text(statement, 5))
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss"
                let start = timeFormatter.date(from: startTimeString)!
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 6)
                
                let wid = WiD(id: id, title: title, detail: detail, date: date, start: start, finish: finish, duration: duration)
                
                sqlite3_finalize(statement)
                
                print("Success to select WiD by ID.")
                return wid
            }
        }
        
        sqlite3_finalize(statement)
        return nil
    }
    
    func selectWiDsByDate(date: Date) -> [WiD] {
        let selectWiDsQuery = "SELECT id, title, detail, date, start, finish, duration FROM WiD WHERE date = ?"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        var wids = [WiD]()
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let title = String(cString: sqlite3_column_text(statement, 1))
                let detail = String(cString: sqlite3_column_text(statement, 2))
                
                let dateString = String(cString: sqlite3_column_text(statement, 3))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateString)!
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finishTimeString = String(cString: sqlite3_column_text(statement, 5))
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss"
                let start = timeFormatter.date(from: startTimeString)!
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 6)
                
                let wid = WiD(id: id, title: title, detail: detail, date: date, start: start, finish: finish, duration: duration)
                wids.append(wid)
            }
            
            sqlite3_finalize(statement)
            print("Success to select WiD.")
        }
        
        return wids
    }
    
    func updateWiD(withID id: Int, detail: String) {
            let updateWiDQuery = "UPDATE WiD SET detail = ? WHERE id = ?"

            var statement: OpaquePointer?
            if sqlite3_prepare_v2(db, updateWiDQuery, -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_text(statement, 1, (detail as NSString).utf8String, -1, nil)
                sqlite3_bind_int(statement, 2, Int32(id))

                if sqlite3_step(statement) != SQLITE_DONE {
                    print("Failed to update WiD.")
                } else {
                    print("Success to update WiD.")
                }

                sqlite3_finalize(statement)
            }
        }
    
    func deleteWiD(withID id: Int) {
        let deleteWiDQuery = "DELETE FROM WiD WHERE id = ?"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteWiDQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Failed to delete WiD.")
            } else {
                print("Success to delete WiD.")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    func deleteAllWiDs() {
        let deleteAllQuery = "DELETE FROM WiD"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, deleteAllQuery, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Failed to delete all WiDs.")
            } else {
                print("Success to delete all WiDs.")
            }
            
            sqlite3_finalize(statement)
        }
    }
}
