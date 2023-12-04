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
    
    private let dateFormatter: DateFormatter
    private let timeFormatter: DateFormatter
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbName)
        
        // 데이터 베이스 열기
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
        // 데이터 베이스 닫기
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        }
    }
    
    func insertWiD(wid: WiD) {
        let insertWiDQuery = "INSERT INTO WiD (title, detail, date, start, finish, duration) VALUES (?, ?, ?, ?, ?, ?)"
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: wid.date)
        
//        let timeFormatter = DateFormatter()
//        timeFormatter.dateFormat = "HH:mm:ss"
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
    
//    func getUniqueYears() -> [String] {
//        let selectYearsQuery = "SELECT DISTINCT strftime('%Y', date) FROM WiD"
//
//        var statement: OpaquePointer?
//        var years: [String] = []
//
//        if sqlite3_prepare_v2(db, selectYearsQuery, -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let year = String(cString: sqlite3_column_text(statement, 0))
//                years.append(year)
//            }
//
//            sqlite3_finalize(statement)
//        }
//
//        return years
//    }
    
    // 데이터베이스의 모든 WiD를 탐색해야 하기 때문에 서비스 객체에 작성해야 함.
    func getUniqueYears() -> [Year] {
        let selectYearsQuery = "SELECT DISTINCT strftime('%Y', date) FROM WiD"
        
        var statement: OpaquePointer?
        var years: [Year] = []

        years.append(Year(id: "지난 1년"))
        
        if sqlite3_prepare_v2(db, selectYearsQuery, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let yearString = String(cString: sqlite3_column_text(statement, 0))
                let year = Year(id: yearString)
                years.append(year)
            }
            
            sqlite3_finalize(statement)
        }

        return years
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
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateString)!
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finishTimeString = String(cString: sqlite3_column_text(statement, 5))
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "HH:mm:ss"
                let start = timeFormatter.date(from: startTimeString)!
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 6)
                
                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration, detail: detail)
                
                sqlite3_finalize(statement)
                
                print("Success to select WiD by ID.")   
                print("selectWiDByID - \(wid)")
                
                return wid
            }
        }
        
        sqlite3_finalize(statement)
        
        return nil
    }
    
    func selectWiDsByDate(date: Date) -> [WiD] {
        let selectWiDsQuery = "SELECT id, title, detail, date, start, finish, duration FROM WiD WHERE date = ?"
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        var wiDList = [WiD]()
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let title = String(cString: sqlite3_column_text(statement, 1))
                let detail = String(cString: sqlite3_column_text(statement, 2))
                
                let dateString = String(cString: sqlite3_column_text(statement, 3))
                let date = dateFormatter.date(from: dateString)!
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finishTimeString = String(cString: sqlite3_column_text(statement, 5))
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm:ss"
                let start = timeFormatter.date(from: startTimeString)!
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 6)
                
                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration, detail: detail)
                wiDList.append(wid)
            }
            
            sqlite3_finalize(statement)
            print("Success to select WiD list by ID.")
        }
        
        wiDList.sort { $0.start < $1.start }
        
        return wiDList
    }
    
    func selectWiDsBetweenDates(startDate: Date, finishDate: Date) -> [WiD] {
        let selectWiDsQuery = "SELECT id, title, detail, date, start, finish, duration FROM WiD WHERE date BETWEEN ? AND ?"
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)
        let finishDateString = dateFormatter.string(from: finishDate)
        
        var wiDList = [WiD]()
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (startDateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (finishDateString as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let title = String(cString: sqlite3_column_text(statement, 1))
                let detail = String(cString: sqlite3_column_text(statement, 2))
                
                let dateString = String(cString: sqlite3_column_text(statement, 3))
                let date = dateFormatter.date(from: dateString)!
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finishTimeString = String(cString: sqlite3_column_text(statement, 5))
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "HH:mm:ss"
                let start = timeFormatter.date(from: startTimeString)!
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 6)
                
                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration, detail: detail)
                wiDList.append(wid)
            }
            
            sqlite3_finalize(statement)
            print("Success to select WiD list betwwen dates.")
        }
        
        wiDList.sort { $0.date < $1.date || ($0.date == $1.date && $0.start < $1.start) }
        
        return wiDList
    }
    
//    func getDailyTotalDictionary(forDate date: Date) -> [String: TimeInterval] {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let dateString = dateFormatter.string(from: date)
//
//        let selectWiDsQuery = "SELECT title, duration FROM WiD WHERE date = ?"
//        var statement: OpaquePointer?
//
//        var titleDurations: [String: TimeInterval] = [:]
//
//        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
//            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)
//
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let title = String(cString: sqlite3_column_text(statement, 0))
//                let duration = sqlite3_column_double(statement, 1)
//
//                if let existingDuration = titleDurations[title] {
//                    titleDurations[title] = existingDuration + duration
//                } else {
//                    titleDurations[title] = duration
//                }
//            }
//
//            sqlite3_finalize(statement)
//        }
//
//        // Dictionary를 총 소요 시간이 높은 순으로 정렬
//        let sortedTitleDurations = titleDurations.sorted { $0.value > $1.value }
//
//        return Dictionary(uniqueKeysWithValues: sortedTitleDurations)
//    }
//
//    func getWeeklyTotalDictionary(forDate date: Date) -> [String: TimeInterval] {
//        let calendar = Calendar.current
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
////        let dateString = dateFormatter.string(from: date)
//
//        let startOfWeek: Date
//        let endOfWeek: Date
//
//        let weekday = calendar.component(.weekday, from: date)
//        if weekday == 1 {
//            startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
//            endOfWeek = date
//        } else {
//            startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
//            endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
//        }
//
//        let selectWiDsQuery = "SELECT title, duration FROM WiD WHERE date >= ? AND date <= ?"
//
//        var statement: OpaquePointer?
//        var titleDurations: [String: TimeInterval] = [:]
//
//        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
//            sqlite3_bind_text(statement, 1, (dateFormatter.string(from: startOfWeek) as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(statement, 2, (dateFormatter.string(from: endOfWeek) as NSString).utf8String, -1, nil)
//
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let title = String(cString: sqlite3_column_text(statement, 0))
//                let duration = sqlite3_column_double(statement, 1)
//
//                if let existingDuration = titleDurations[title] {
//                    titleDurations[title] = existingDuration + duration
//                } else {
//                    titleDurations[title] = duration
//                }
//            }
//
//            sqlite3_finalize(statement)
//        }
//
//        // Dictionary를 총 소요 시간이 높은 순으로 정렬
//        let sortedTitleDurations = titleDurations.sorted { $0.value > $1.value }
//
//        return Dictionary(uniqueKeysWithValues: sortedTitleDurations)
//    }
    
//    func getWeeklyDictionary(forDate date: Date) -> [String: TimeInterval] {
//        let calendar = Calendar.current
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//
//        let startOfWeek: Date
//        let endOfWeek: Date
//        
//        let weekday = calendar.component(.weekday, from: date)
//        if weekday == 1 {
//            startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
//            endOfWeek = date
//        } else {
//            startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
//            endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
//        }
//
//        let selectWiDsQuery = "SELECT title, duration FROM WiD WHERE date >= ? AND date <= ?"
//        
//        var statement: OpaquePointer?
//        var titleDurations: [String: TimeInterval] = [:]
//        
//        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
//            sqlite3_bind_text(statement, 1, (dateFormatter.string(from: startOfWeek) as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(statement, 2, (dateFormatter.string(from: endOfWeek) as NSString).utf8String, -1, nil)
//
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let title = String(cString: sqlite3_column_text(statement, 0))
//                let duration = sqlite3_column_double(statement, 1)
//
//                if let existingDuration = titleDurations[title] {
//                    titleDurations[title] = existingDuration + duration
//                } else {
//                    titleDurations[title] = duration
//                }
//            }
//
//            sqlite3_finalize(statement)
//        }
//
//        var weeklyAverages: [String: TimeInterval] = [:]
//
//        for (title, totalDuration) in titleDurations {
//            // Calculate the average duration for each title
//            let daysWithStudyData = titleDurations.count
//            let averageDuration = totalDuration / Double(daysWithStudyData)
//
//            weeklyAverages[title] = averageDuration
//        }
//
//        return weeklyAverages
//    }
    
//    func getMonthlyTotalDictionary(forDate date: Date) -> [String: TimeInterval] {
//        let calendar = Calendar.current
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
////        let dateString = dateFormatter.string(from: date)
//        
//        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
//        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
//        
//        let selectWiDsQuery = "SELECT title, duration FROM WiD WHERE date >= ? AND date <= ?"
//        
//        var statement: OpaquePointer?
//        var titleDurations: [String: TimeInterval] = [:]
//        
//        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
//            sqlite3_bind_text(statement, 1, (dateFormatter.string(from: startOfMonth) as NSString).utf8String, -1, nil)
//            sqlite3_bind_text(statement, 2, (dateFormatter.string(from: endOfMonth) as NSString).utf8String, -1, nil)
//
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let title = String(cString: sqlite3_column_text(statement, 0))
//                let duration = sqlite3_column_double(statement, 1)
//
//                if let existingDuration = titleDurations[title] {
//                    titleDurations[title] = existingDuration + duration
//                } else {
//                    titleDurations[title] = duration
//                }
//            }
//
//            sqlite3_finalize(statement)
//        }
//
//        // Dictionary를 총 소요 시간이 높은 순으로 정렬
//        let sortedTitleDurations = titleDurations.sorted { $0.value > $1.value }
//
//        return Dictionary(uniqueKeysWithValues: sortedTitleDurations)
//    }

    func selectWiDsByDetail(detail: String) -> [WiD] {
        // If the search detail is empty, return an empty array
        guard !detail.isEmpty else {
            return []
        }

        let selectWiDsQuery = "SELECT id, title, detail, date, start, finish, duration FROM WiD WHERE detail LIKE ?"

        var wiDList = [WiD]()
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
            let searchString = "%\(detail)%"
            sqlite3_bind_text(statement, 1, (searchString as NSString).utf8String, -1, nil)

            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))

                let title = String(cString: sqlite3_column_text(statement, 1))
                let detail = String(cString: sqlite3_column_text(statement, 2))

                let dateString = String(cString: sqlite3_column_text(statement, 3))
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
                let date = dateFormatter.date(from: dateString)!

                let startTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finishTimeString = String(cString: sqlite3_column_text(statement, 5))
//                let timeFormatter = DateFormatter()
//                timeFormatter.dateFormat = "HH:mm:ss"
                let start = timeFormatter.date(from: startTimeString)!
                let finish = timeFormatter.date(from: finishTimeString)!

                let duration = sqlite3_column_double(statement, 6)

                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration, detail: detail)
                wiDList.append(wid)
            }

            sqlite3_finalize(statement)
            print("Success to select wiDList by detail.")
        }
        
        wiDList.sort { $0.date < $1.date || ($0.date == $1.date && $0.start < $1.start) }

        return wiDList
    }
    
    func updateWiD(withID id: Int, newTitle: String, newStart: Date, newFinish: Date, newDuration: TimeInterval, newDetail: String) {
        let updateWiDQuery = "UPDATE WiD SET title = ?, start = ?, finish = ?, duration = ?, detail = ? WHERE id = ?"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateWiDQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (newTitle as NSString).utf8String, -1, nil)
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateFormat = "HH:mm:ss"
            let startString = timeFormatter.string(from: newStart)
            sqlite3_bind_text(statement, 2, (startString as NSString).utf8String, -1, nil)
            let finishString = timeFormatter.string(from: newFinish)
            sqlite3_bind_text(statement, 3, (finishString as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 4, newDuration)
            sqlite3_bind_text(statement, 5, (newDetail as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 6, Int32(id))

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
    
//    func deleteAllWiDs() {
//        let deleteAllQuery = "DELETE FROM WiD"
//
//        var statement: OpaquePointer?
//        if sqlite3_prepare_v2(db, deleteAllQuery, -1, &statement, nil) == SQLITE_OK {
//            if sqlite3_step(statement) != SQLITE_DONE {
//                print("Failed to delete all wiDList.")
//            } else {
//                print("Success to delete all wiDList.")
//            }
//
//            sqlite3_finalize(statement)
//        }
//    }
}
