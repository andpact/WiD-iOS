//
//  WiDService.swift
//  WiD
//
//  Created by jjkim on 2023/07/07.
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
        let createWiDTableQuery = "CREATE TABLE IF NOT EXISTS WiD (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, title TEXT, start TEXT, finish TEXT, duration REAL)"
        
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
        let insertWiDQuery = "INSERT INTO WiD (date, title, start, finish, duration) VALUES (?, ?, ?, ?, ?)"
        
        let dateString = dateFormatter.string(from: wid.date)
        
        let startTimeString = timeFormatter.string(from: wid.start)
        let finishTimeString = timeFormatter.string(from: wid.finish)
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertWiDQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (wid.title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (startTimeString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (finishTimeString as NSString).utf8String, -1, nil)
            sqlite3_bind_double(statement, 5, wid.duration)
            
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
//    func getUniqueYears() -> [Year] {
//        let selectYearsQuery = "SELECT DISTINCT strftime('%Y', date) FROM WiD"
//        
//        var statement: OpaquePointer?
//        var years: [Year] = []
//
//        years.append(Year(id: "지난 1년"))
//        
//        if sqlite3_prepare_v2(db, selectYearsQuery, -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let yearString = String(cString: sqlite3_column_text(statement, 0))
//                let year = Year(id: yearString)
//                years.append(year)
//            }
//            
//            sqlite3_finalize(statement)
//        }
//
//        return years
//    }

    func selectWiDByID(id: Int) -> WiD? {
        let selectWiDByIDQuery = "SELECT id, date, title, start, finish, duration FROM WiD WHERE id = ?"
        
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDByIDQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let dateString = String(cString: sqlite3_column_text(statement, 1))
                let date = dateFormatter.date(from: dateString)!
                
                let title = String(cString: sqlite3_column_text(statement, 2))
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 3))
                let start = timeFormatter.date(from: startTimeString)!
                
                let finishTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 5)
                
                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration)
                
                sqlite3_finalize(statement)
                
                print("Success to select WiD by ID.")   
                print("selectWiDByID - \(wid)")
                
                return wid
            }
        }
        
        sqlite3_finalize(statement)
        
        return nil
    }
    
    func selectWiDListByDate(date: Date) -> [WiD] {
        let selectWiDsQuery = "SELECT id, date, title, start, finish, duration FROM WiD WHERE date = ? ORDER BY start ASC"
        
        let dateString = dateFormatter.string(from: date)
        
        var wiDList = [WiD]()
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (dateString as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))

                let dateString = String(cString: sqlite3_column_text(statement, 1))
                let date = dateFormatter.date(from: dateString)!
                
                let title = String(cString: sqlite3_column_text(statement, 2))
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 3))
                let start = timeFormatter.date(from: startTimeString)!
                
                let finishTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 5)
                
                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration)
                wiDList.append(wid)
            }
            
            sqlite3_finalize(statement)
            print("Success to select WiD list by ID.")
        }
        
        return wiDList
    }
    
    func selectWiDListByRandomDate() -> [WiD] {
        let selectRandomDateQuery = "SELECT DISTINCT date FROM WiD"
        
        var dateList = [Date]()
        var dateStatement: OpaquePointer?
        
        guard sqlite3_prepare_v2(db, selectRandomDateQuery, -1, &dateStatement, nil) == SQLITE_OK else {
            print("Error preparing date query")
            return []
        }
        
        while sqlite3_step(dateStatement) == SQLITE_ROW {
            let dateString = String(cString: sqlite3_column_text(dateStatement, 0))
            if let date = dateFormatter.date(from: dateString) {
                dateList.append(date)
            }
        }
        
        sqlite3_finalize(dateStatement)
        
        // Check if the date list is empty
        guard !dateList.isEmpty else {
            return []
        }
        
        // Choose a random date from the list
        let randomDate = dateList.randomElement()!
        
        // Use the selected date to fetch the WiDList
        return selectWiDListByDate(date: randomDate)
    }

    
    func selectWiDListBetweenDates(startDate: Date, finishDate: Date) -> [WiD] {
        let selectWiDsQuery = "SELECT id, date, title, start, finish, duration FROM WiD WHERE date BETWEEN ? AND ? ORDER BY date ASC, start ASC"
        
        let startDateString = dateFormatter.string(from: startDate)
        let finishDateString = dateFormatter.string(from: finishDate)
        
        var wiDList = [WiD]()
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (startDateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (finishDateString as NSString).utf8String, -1, nil)
            
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                
                let dateString = String(cString: sqlite3_column_text(statement, 1))
                let date = dateFormatter.date(from: dateString)!
                
                let title = String(cString: sqlite3_column_text(statement, 2))

//                let date = Calendar.current.startOfDay(for: dateFormatter.date(from: dateString)!)
//                print("selectWiDsBetweenDates - date : \(formatDate(date, format: "yyyy-MM-dd a HH:mm:ss"))")
                
                let startTimeString = String(cString: sqlite3_column_text(statement, 3))
                let start = timeFormatter.date(from: startTimeString)!
                
                let finishTimeString = String(cString: sqlite3_column_text(statement, 4))
                let finish = timeFormatter.date(from: finishTimeString)!
                
                let duration = sqlite3_column_double(statement, 5)
                
                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration)
                wiDList.append(wid)
            }
            
            sqlite3_finalize(statement)
            print("Success to select WiD list betwwen dates.")
        }
        
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

//    func selectWiDsByDetail(detail: String) -> [WiD] {
//        // If the search detail is empty, return an empty array
//        guard !detail.isEmpty else {
//            return []
//        }
//
//        let selectWiDsQuery = "SELECT id, title, detail, date, start, finish, duration FROM WiD WHERE detail LIKE ? ORDER BY date ASC, start ASC"
//
//        var wiDList = [WiD]()
//        var statement: OpaquePointer?
//        if sqlite3_prepare_v2(db, selectWiDsQuery, -1, &statement, nil) == SQLITE_OK {
//            let searchString = "%\(detail)%"
//            sqlite3_bind_text(statement, 1, (searchString as NSString).utf8String, -1, nil)
//
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let id = Int(sqlite3_column_int(statement, 0))
//
//                let title = String(cString: sqlite3_column_text(statement, 1))
//
//                let detail = String(cString: sqlite3_column_text(statement, 2))
//
//                let dateString = String(cString: sqlite3_column_text(statement, 3))
//                let date = dateFormatter.date(from: dateString)!
//
//                let startTimeString = String(cString: sqlite3_column_text(statement, 4))
//                let start = timeFormatter.date(from: startTimeString)!
//
//                let finishTimeString = String(cString: sqlite3_column_text(statement, 5))
//                let finish = timeFormatter.date(from: finishTimeString)!
//
//                let duration = sqlite3_column_double(statement, 6)
//
//                let wid = WiD(id: id, date: date, title: title, start: start, finish: finish, duration: duration, detail: detail)
//                wiDList.append(wid)
//            }
//
//            sqlite3_finalize(statement)
//            print("Success to select wiDList by detail.")
//        }
//
////        wiDList.sort { $0.date < $1.date || ($0.date == $1.date && $0.start < $1.start) }
//
//        return wiDList
//    }
    
    func updateWiD(withID id: Int, newTitle: String, newStart: Date, newFinish: Date, newDuration: TimeInterval) {
        let updateWiDQuery = "UPDATE WiD SET title = ?, start = ?, finish = ?, duration = ? WHERE id = ?"

        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, updateWiDQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (newTitle as NSString).utf8String, -1, nil)
            
            let startString = timeFormatter.string(from: newStart)
            sqlite3_bind_text(statement, 2, (startString as NSString).utf8String, -1, nil)
            
            let finishString = timeFormatter.string(from: newFinish)
            sqlite3_bind_text(statement, 3, (finishString as NSString).utf8String, -1, nil)
            
            sqlite3_bind_double(statement, 4, newDuration)
            
            sqlite3_bind_int(statement, 5, Int32(id))

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
