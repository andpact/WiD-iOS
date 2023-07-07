//
//  WiDService.swift
//  WiD
//
//  Created by jjkim on 2023/07/07.
//

import Foundation
import SQLite3

class WiDService {
    private let dbPath: String
    private var db: OpaquePointer?

    init(dbPath: String) {
        self.dbPath = dbPath
    }

    func openDatabase() {
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            print("Failed to open database")
            return
        }

        createTableIfNeeded()
    }

    func closeDatabase() {
        sqlite3_close(db)
    }

    func createTableIfNeeded() {
        let createTableQuery = """
            CREATE TABLE IF NOT EXISTS WiD (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT,
                detail TEXT,
                date REAL,
                start REAL,
                finish REAL,
                duration REAL
            );
        """

        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to create table: \(errmsg)")
        }
    }

    func insert(wiD: WiD) {
        let insertQuery = """
            INSERT INTO WiD (title, detail, date, start, finish, duration)
            VALUES (?, ?, ?, ?, ?, ?);
        """

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }

            sqlite3_bind_text(statement, 1, (wiD.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (wiD.detail as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 3, wiD.date.timeIntervalSince1970)
            sqlite3_bind_double(statement, 4, wiD.start.timeIntervalSince1970)
            sqlite3_bind_double(statement, 5, wiD.finish.timeIntervalSince1970)
            sqlite3_bind_double(statement, 6, wiD.duration)

            if sqlite3_step(statement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Failed to insert WiD: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to prepare statement: \(errmsg)")
        }
    }
    
    func fetchByDate() -> [Date: [WiD]] {
        let selectQuery = "SELECT * FROM WiD ORDER BY date;"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }

            var wiDsByDate: [Date: [WiD]] = [:]
            var currentDate: Date?
            var currentWiDs: [WiD] = []

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let detail = String(cString: sqlite3_column_text(statement, 2))
                let date = Date(timeIntervalSince1970: sqlite3_column_double(statement, 3))
                let start = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
                let finish = Date(timeIntervalSince1970: sqlite3_column_double(statement, 5))
                let duration = sqlite3_column_double(statement, 6)

                let wiD = WiD(id: id, title: title, detail: detail, date: date, start: start, finish: finish, duration: duration)

                if let currentDate = currentDate, !Calendar.current.isDate(date, inSameDayAs: currentDate) {
                    wiDsByDate[currentDate] = currentWiDs
                    currentWiDs = []
                }

                currentDate = date
                currentWiDs.append(wiD)
            }

            if let currentDate = currentDate {
                wiDsByDate[currentDate] = currentWiDs
            }

            return wiDsByDate
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to prepare statement: \(errmsg)")
            return [:]
        }
    }

    func fetchAll() -> [WiD] {
        let selectQuery = "SELECT * FROM WiD;"
        var wiDs: [WiD] = []

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectQuery, -1, &statement, nil) == SQLITE_OK {
            defer {
                sqlite3_finalize(statement)
            }

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let title = String(cString: sqlite3_column_text(statement, 1))
                let detail = String(cString: sqlite3_column_text(statement, 2))
                let date = Date(timeIntervalSince1970: sqlite3_column_double(statement, 3))
                let start = Date(timeIntervalSince1970: sqlite3_column_double(statement, 4))
                let finish = Date(timeIntervalSince1970: sqlite3_column_double(statement, 5))
                let duration = sqlite3_column_double(statement, 6)

                let wiD = WiD(id: id, title: title, detail: detail, date: date, start: start, finish: finish, duration: duration)
                wiDs.append(wiD)
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Failed to prepare statement: \(errmsg)")
        }

        return wiDs
    }
}
