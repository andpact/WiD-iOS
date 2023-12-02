//
//  DiaryService.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import Foundation
import SQLite3

class DiaryService {
    private var db: OpaquePointer?
    private let dbName = "diaryDB.sqlite"
    
    init() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        
        // 데이터 베이스 열기
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Unable to open database.")
            return
        }
        
        // Diary 테이블 생성
        let createDiaryTableQuery = "CREATE TABLE IF NOT EXISTS Diary (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT UNIQUE, title TEXT, content TEXT)"
        
        if sqlite3_exec(db, createDiaryTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Unable to create Diary table: \(errmsg)")
        }
    }
    
    deinit {
        // 데이터 베이스 닫기
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
    }
    
    func insertDiary(diary: Diary) {
        let insertDiaryQuery = "INSERT INTO Diary (date, title, content) VALUES (?, ?, ?)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: diary.date)
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertDiaryQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, dateString, -1, nil)
            sqlite3_bind_text(statement, 2, diary.title, -1, nil)
            sqlite3_bind_text(statement, 3, diary.content, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Failed to insert Diary.")
            } else {
                print("Success to insert Diary.")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    func selectDiaryByDate(date: Date) -> Diary? {
        let selectDiaryQuery = "SELECT * FROM Diary WHERE date = ?"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectDiaryQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, dateString, -1, nil)

            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let dateString = String(cString: sqlite3_column_text(statement, 1))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateString)!
                
                let title = String(cString: sqlite3_column_text(statement, 2))
                let content = String(cString: sqlite3_column_text(statement, 3))
                
                let diary = Diary(id: id, date: date, title: title, content: content)
                sqlite3_finalize(statement)

                return diary
            }
        }

        return nil
    }
    
    func updateDiary(withID id: Int, newTitle: String, newContent: String) {
        let updateDiaryQuery = "UPDATE Diary SET title = ?, content = ? WHERE id = ?"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateDiaryQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (newTitle as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (newContent as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(id))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("Failed to update Diary.")
            } else {
                print("Success to update Diary.")
            }
            
            sqlite3_finalize(statement)
        }
    }
}
