//
//  DiaryService.swift
//  WiD
//
//  Created by jjkim on 2023/12/02.
//

import Foundation
import SQLite3

/*
 쿼리로 정렬해서 리스트 가져오기
 쿼리로 정렬해서 리스트 가져오기
 쿼리로 정렬해서 리스트 가져오기
 쿼리로 정렬해서 리스트 가져오기
 쿼리로 정렬해서 리스트 가져오기
 */
class DiaryService {
    private var db: OpaquePointer?
    private let dbName = "diaryDB.sqlite"
    
    private let dateFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        
        // 데이터 베이스 열기
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("DiaryService : Unable to open database")
            return
        }
        
        // Diary 테이블 생성
        let createDiaryTableQuery = "CREATE TABLE IF NOT EXISTS Diary (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT UNIQUE, title TEXT, content TEXT)"
        
        if sqlite3_exec(db, createDiaryTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("DiaryService : Unable to create Diary table: \(errmsg)")
        }
    }
    
    deinit {
        // 데이터 베이스 닫기
        if sqlite3_close(db) != SQLITE_OK {
            print("DiaryService : Error closing database")
        }
    }
    
    func createDiary(diary: Diary) {
        print("DiaryService : createDiary executed")
        
        let insertDiaryQuery = "INSERT INTO Diary (date, title, content) VALUES (?, ?, ?)"
        
        let dateString = dateFormatter.string(from: diary.date)
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertDiaryQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (diary.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (diary.content as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("DiaryService : createDiary failed")
            } else {
                print("DiaryService : createDiary success")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
    func readTotalDiaryCount() -> Int {
        print("DiaryService: getTotalDiaryCount executed")
        
        let query = "SELECT COUNT(*) FROM Diary"
        var statement: OpaquePointer?
        var totalDiaryCount = 0
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_ROW {
                totalDiaryCount = Int(sqlite3_column_int(statement, 0))
            }
            sqlite3_finalize(statement)
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("DiaryService: Error preparing total Diary count query: \(errmsg)")
        }
        
        return totalDiaryCount
    }
    
    func readDiaryByDate(date: Date) -> Diary? {
        print("DiaryService : readDiaryByDate executed")
        
        let selectDiaryQuery = "SELECT id, date, title, content FROM Diary WHERE date = ?"

        let dateString = dateFormatter.string(from: date)

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectDiaryQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)

            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let dateString = String(cString: sqlite3_column_text(statement, 1))
                let date = dateFormatter.date(from: dateString)!
                
                let title = String(cString: sqlite3_column_text(statement, 2))
                let content = String(cString: sqlite3_column_text(statement, 3))
                
                let diary = Diary(id: id, date: date, title: title, content: content)
                sqlite3_finalize(statement)

                print("DiaryService : readDiaryByDate success")
                
                return diary
            }
        }

        return nil
    }
    
//    func selectDiaryByTitle(title: String) -> [Diary] {
//        guard !title.isEmpty else {
//            return []
//        }
//        
//        let selectDiaryByTitleQuery = "SELECT id, date, title, content FROM Diary WHERE title = ? ORDER BY date ASC"
//
//        var diaryList: [Diary] = []
//
//        var statement: OpaquePointer?
//        if sqlite3_prepare_v2(db, selectDiaryByTitleQuery, -1, &statement, nil) == SQLITE_OK {
//            let titleCString = (title as NSString).utf8String
//            sqlite3_bind_text(statement, 1, titleCString, -1, nil)
//
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let id = Int(sqlite3_column_int(statement, 0))
//
//                let dateString = String(cString: sqlite3_column_text(statement, 1))
//                let date = dateFormatter.date(from: dateString)!
//
//                let title = String(cString: sqlite3_column_text(statement, 2))
//                let content = String(cString: sqlite3_column_text(statement, 3))
//
//                let diary = Diary(id: id, date: date, title: title, content: content)
//                diaryList.append(diary)
//            }
//
//            sqlite3_finalize(statement)
//        }
//
//        return diaryList
//    }
//    
//    func selectDiaryByContent(content: String) -> [Diary] {
//        guard !content.isEmpty else {
//            return []
//        }
//        
//        let selectDiaryByContentQuery = "SELECT id, date, title, content FROM Diary WHERE content LIKE ? ORDER BY date ASC"
//
//        var diaryList: [Diary] = []
//
//        var statement: OpaquePointer?
//        if sqlite3_prepare_v2(db, selectDiaryByContentQuery, -1, &statement, nil) == SQLITE_OK {
//            let contentCString = ("%\(content)%" as NSString).utf8String
//            sqlite3_bind_text(statement, 1, contentCString, -1, nil)
//
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let id = Int(sqlite3_column_int(statement, 0))
//
//                let dateString = String(cString: sqlite3_column_text(statement, 1))
//                let date = dateFormatter.date(from: dateString)!
//
//                let title = String(cString: sqlite3_column_text(statement, 2))
//                let content = String(cString: sqlite3_column_text(statement, 3))
//
//                let diary = Diary(id: id, date: date, title: title, content: content)
//                diaryList.append(diary)
//            }
//
//            sqlite3_finalize(statement)
//        }
//
//        return diaryList
//    }

    
    func readDiaryByTitleOrContent(searchText: String) -> [Diary] {
        print("DiaryService : readDiaryByTitleOrContent executed")
        
        guard !searchText.isEmpty else {
            return []
        }
        
        let selectDiaryByTitleOrContentQuery = "SELECT id, date, title, content FROM Diary WHERE title LIKE ? OR content LIKE ? ORDER BY date ASC"
        
        var diaryList: [Diary] = []
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectDiaryByTitleOrContentQuery, -1, &statement, nil) == SQLITE_OK {
            let keywordCString = ("%\(searchText)%" as NSString).utf8String
            sqlite3_bind_text(statement, 1, keywordCString, -1, nil)
            sqlite3_bind_text(statement, 2, keywordCString, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let dateString = String(cString: sqlite3_column_text(statement, 1))
                let date = dateFormatter.date(from: dateString)!
                
                let title = String(cString: sqlite3_column_text(statement, 2))
                let content = String(cString: sqlite3_column_text(statement, 3))
                
                let diary = Diary(id: id, date: date, title: title, content: content)
                diaryList.append(diary)
            }
            
            sqlite3_finalize(statement)
        }
        
        return diaryList
    }

    
    func updateDiary(withID id: Int, newTitle: String, newContent: String) {
        print("DiaryService : updateDiary executed")
        
        let updateDiaryQuery = "UPDATE Diary SET title = ?, content = ? WHERE id = ?"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateDiaryQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (newTitle as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (newContent as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(id))
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("DiaryService : updateDiary failed")
            } else {
                print("DiaryService : updateDiary success")
            }
            
            sqlite3_finalize(statement)
        }
    }
    
//    func deleteAllDiaryList() {
//        let deleteAllQuery = "DELETE FROM Diary"
//
//        var statement: OpaquePointer?
//        if sqlite3_prepare_v2(db, deleteAllQuery, -1, &statement, nil) == SQLITE_OK {
//            if sqlite3_step(statement) != SQLITE_DONE {
//                print("Failed to delete all DiaryList.")
//            } else {
//                print("Success to delete all DiaryList.")
//            }
//
//            sqlite3_finalize(statement)
//        }
//    }
}
