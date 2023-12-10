//
//  WiDListUtil.swift
//  WiD
//
//  Created by jjkim on 2023/11/15.
//

import SwiftUI

func getEmptyWiDListFromWiDList(date: Date, wiDList: [WiD]) -> [WiD] {
    let calendar = Calendar.current
    var emptyWiDStart = calendar.startOfDay(for: date)

    var emptyWiDList: [WiD] = []

    for index in 0..<wiDList.count {
        let currentWiD = wiDList[index]

        let currentWIDStartComponents = calendar.dateComponents([.hour, .minute, .second], from: currentWiD.start)
        
        let emptyWiDFinish = calendar.date(bySettingHour: currentWIDStartComponents.hour!, minute: currentWIDStartComponents.minute!, second: currentWIDStartComponents.second!, of: date)
        
        // 빈 WiD의 시작 시간과 종료 시간이 같으면 소요 시간 0의 빈 WiD가 나오므로 걸러줌.
        if emptyWiDStart == emptyWiDFinish {
            let currentWIDFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: currentWiD.finish)
            
            emptyWiDStart = calendar.date(bySettingHour: currentWIDFinishComponents.hour!, minute: currentWIDFinishComponents.minute!, second: currentWIDFinishComponents.second!, of: date)!
            
            // 빈 WiD를 마지막으로 추가함.
            if index == wiDList.count - 1 {
                let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
                let lastEmptyWiD = WiD(id: index + 1, date: date, title: "", start: emptyWiDStart, finish: endOfDay, duration: endOfDay.timeIntervalSince(emptyWiDStart), detail: "")
                
                emptyWiDList.append(lastEmptyWiD)
                
                break
            }
            
            continue
        }
        
        // id에 0을 넣지 말고, 각각 다르게 설정해줘야 정상 동작함.
        let emptyWiD = WiD(id: index, date: date, title: "", start: emptyWiDStart, finish: emptyWiDFinish!, duration: emptyWiDFinish!.timeIntervalSince(emptyWiDStart), detail: "")
        emptyWiDList.append(emptyWiD)
        
        let currentWIDFinishComponents = calendar.dateComponents([.hour, .minute, .second], from: currentWiD.finish)
        
        emptyWiDStart = calendar.date(bySettingHour: currentWIDFinishComponents.hour!, minute: currentWIDFinishComponents.minute!, second: currentWIDFinishComponents.second!, of: date)!
        
        // 빈 WiD를 마지막으로 추가함.
        if index == wiDList.count - 1 {
            let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
            let lastEmptyWiD = WiD(id: index + 1, date: date, title: "", start: emptyWiDStart, finish: endOfDay, duration: endOfDay.timeIntervalSince(emptyWiDStart), detail: "")
            
            emptyWiDList.append(lastEmptyWiD)
            
            break
        }
    }

    return emptyWiDList
}

func getRandomWiDList(days: Int) -> [WiD] {
    var randomWiDList: [WiD] = []

    let calendar = Calendar.current
    let startDate = Date()
    let finishDate = calendar.date(byAdding: .day, value: days - 1, to: startDate) ?? Date()

    // currentDate의 시간을 오전 12:00:00으로 설정.
    var currentDate = calendar.startOfDay(for: startDate)

    while currentDate <= finishDate {
        let wiD = WiD(id: 0,
                      date: currentDate,
                      title: "STUDY",
                      start: Date(),
                      finish: Date(),
                      duration: 3 * 60 * 60,
                      detail: "Detail"
        )

        randomWiDList.append(wiD)

        let randomMinutes = Int(arc4random_uniform(60))
        let randomSeconds = Int(arc4random_uniform(60))

        let randomDuration = TimeInterval((randomMinutes * 60) + randomSeconds)
        let wiD2 = WiD(id: 0,
                      date: currentDate,
                      title: "STUDY",
                      start: Date(),
                      finish: Date(),
                      duration: randomDuration,
                      detail: "Detail"
        )

        randomWiDList.append(wiD2)

        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
    }

    return randomWiDList
}

func getTotalDurationFromWiDList(wiDList: [WiD]) -> TimeInterval {
    let totalDuration = wiDList.reduce(0) { $0 + $1.duration }
    return totalDuration
}

func getTotalDurationPercentageFromWiDList(wiDList: [WiD]) -> Int {
    let totalDuration = getTotalDurationFromWiDList(wiDList: wiDList)
    let totalSecondsIn24Hours: TimeInterval = 24 * 60 * 60
    
    if totalSecondsIn24Hours > 0 {
        let percentage = Int((totalDuration / totalSecondsIn24Hours) * 100)
        return min(percentage, 100) // Ensure the percentage is within [0, 100] range
    } else {
        return 0
    }
}

func getTotalDurationDictionaryByTitle(wiDList: [WiD]) -> [String: TimeInterval] {
    var titleTotalDuration: [String: TimeInterval] = [:]

    for wiD in wiDList {
        if let existingDuration = titleTotalDuration[wiD.title] {
            titleTotalDuration[wiD.title] = existingDuration + wiD.duration
        } else {
            titleTotalDuration[wiD.title] = wiD.duration
        }
    }

    // Dictionary를 소요시간에 따라 내림차순 정렬
    let sortedTitleTotalDuration = titleTotalDuration.sorted { $0.value > $1.value }

    // 정렬된 Dictionary를 새로운 Dictionary로 변환
    let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedTitleTotalDuration)

    return sortedDictionary
}

func getTotalDurationDictionaryByDate(wiDList: [WiD]) -> [Date: TimeInterval] {
    var dateTotalDuration: [Date: TimeInterval] = [:]

    for wiD in wiDList {
        if let existingDuration = dateTotalDuration[wiD.date] {
            dateTotalDuration[wiD.date] = existingDuration + wiD.duration
        } else {
            dateTotalDuration[wiD.date] = wiD.duration
        }
    }

    // Dictionary를 날짜에 따라 내림차순 정렬
    let sortedDateTotalDuration = dateTotalDuration.sorted { $0.key > $1.key }

    // 정렬된 Dictionary를 새로운 Dictionary로 변환
    let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedDateTotalDuration)

    return sortedDictionary
}

//func getDailyAllTitleDurationDictionary(wiDList: [WiD], forDate date: Date) -> [String: TimeInterval] {
//    var titleTotalDuration: [String: TimeInterval] = [:]
//
//    let filteredWiDList = wiDList.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
//
//    for wiD in filteredWiDList {
//        if let existingDuration = titleTotalDuration[wiD.title] {
//            titleTotalDuration[wiD.title] = existingDuration + wiD.duration
//        } else {
//            titleTotalDuration[wiD.title] = wiD.duration
//        }
//    }
//
//    // Dictionary를 소요시간에 따라 내림차순 정렬
//    let sortedTitleTotalDuration = titleTotalDuration.sorted { $0.value > $1.value }
//
//    // 정렬된 Dictionary를 새로운 Dictionary로 변환
//    let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedTitleTotalDuration)
//
//    return sortedDictionary
//}
//
//func getWeeklyAllTitleDurationDictionary(wiDList: [WiD], forDate date: Date) -> [String: TimeInterval] {
//    var titleTotalDuration: [String: TimeInterval] = [:]
//
//    let calendar = Calendar.current
//    let startOfWeek: Date
//    let endOfWeek: Date
//
//    let weekday = calendar.component(.weekday, from: date)
//    if weekday == 1 {
//        startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
//        endOfWeek = date
//    } else {
//        startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
//        endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
//    }
//
//    for wiD in wiDList {
//        if (startOfWeek...endOfWeek).contains(wiD.date) {
//            if let existingDuration = titleTotalDuration[wiD.title] {
//                titleTotalDuration[wiD.title] = existingDuration + wiD.duration
//            } else {
//                titleTotalDuration[wiD.title] = wiD.duration
//            }
//        }
//    }
//
//    // 정렬
//    let sortedTitleTotalDuration = titleTotalDuration.sorted { $0.value > $1.value }
//    return Dictionary(uniqueKeysWithValues: sortedTitleTotalDuration)
//}
//
//func getMonthlyAllTitleDurationDictionary(wiDList: [WiD], forDate date: Date) -> [String: TimeInterval] {
//    var titleTotalDuration: [String: TimeInterval] = [:]
//
//    let calendar = Calendar.current
//    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
//    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
//
//    for wiD in wiDList {
//        if (startOfMonth...endOfMonth).contains(wiD.date) {
//            if let existingDuration = titleTotalDuration[wiD.title] {
//                titleTotalDuration[wiD.title] = existingDuration + wiD.duration
//            } else {
//                titleTotalDuration[wiD.title] = wiD.duration
//            }
//        }
//    }
//
//    // Dictionary를 소요시간에 따라 내림차순 정렬
//    let sortedTitleTotalDuration = titleTotalDuration.sorted { $0.value > $1.value }
//
//    // 정렬된 Dictionary를 새로운 Dictionary로 변환
//    let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedTitleTotalDuration)
//
//    return sortedDictionary
//}

func getAverageDurationDictionaryByTitle(wiDList: [WiD]) -> [String: TimeInterval] {
    var titleTotalDuration: [String: [Date: TimeInterval]] = [:]

    for wiD in wiDList {
        if var existingDurations = titleTotalDuration[wiD.title] {
            existingDurations[wiD.date, default: 0] += wiD.duration
            titleTotalDuration[wiD.title] = existingDurations
        } else {
            titleTotalDuration[wiD.title] = [wiD.date: wiD.duration]
        }
    }

    // Calculate average duration for each title
    var averageDurationByTitle: [String: TimeInterval] = [:]

    for (title, durations) in titleTotalDuration {
        let count = durations.count

        if count > 0 {
            var totalDuration: TimeInterval = 0

            for (_, duration) in durations {
                totalDuration += duration
            }

            averageDurationByTitle[title] = totalDuration / TimeInterval(count)
        }
    }

//    return averageDurationByTitle
    
    // Dictionary를 소요시간에 따라 내림차순 정렬
    let sortedTitleAverageDuration = averageDurationByTitle.sorted { $0.value > $1.value }

    // 정렬된 Dictionary를 새로운 Dictionary로 변환
    let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedTitleAverageDuration)

    return sortedDictionary
}

//func getWeeklyAverageTitleDuration(wiDList: [WiD], title: String, forDate date: Date) -> TimeInterval {
//    var durationsByDate: [Date: TimeInterval] = [:]
//
//    let calendar = Calendar.current
//    let startOfWeek: Date
//    let endOfWeek: Date
//
//    let weekday = calendar.component(.weekday, from: date)
//    if weekday == 1 {
//        startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
//        endOfWeek = date
//    } else {
//        startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
//        endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
//    }
//
//    var currentDate = startOfWeek
//    while currentDate <= endOfWeek {
//        let filteredWiDList = wiDList.filter { wiD in
//            return calendar.isDate(wiD.date, equalTo: currentDate, toGranularity: .day) && wiD.title == title
//        }
//
//        let totalDuration = filteredWiDList.reduce(0) { $0 + $1.duration }
//        durationsByDate[currentDate] = totalDuration
//
//        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
//            break
//        }
//        currentDate = nextDate
//    }
//
//    let averageDurations = durationsByDate.values
//    let totalDuration = averageDurations.reduce(0, +)
//    let numberOfDays = Double(durationsByDate.count)
//
//    return numberOfDays > 0 ? totalDuration / numberOfDays : 0
//}

func getMaxDurationDictionaryByTitle(wiDList: [WiD]) -> [String: TimeInterval] {
    var titleTotalDuration: [String: [Date: TimeInterval]] = [:]

    for wiD in wiDList {
        if var existingDurations = titleTotalDuration[wiD.title] {
            existingDurations[wiD.date, default: 0] += wiD.duration
            titleTotalDuration[wiD.title] = existingDurations
        } else {
            titleTotalDuration[wiD.title] = [wiD.date: wiD.duration]
        }
    }

    // Calculate max duration for each title
    var maxDurationByTitle: [String: TimeInterval] = [:]

    for (title, durations) in titleTotalDuration {
        if let maxDuration = durations.values.max() {
            maxDurationByTitle[title] = maxDuration
        }
    }

//    return maxDurationByTitle
    
    // Dictionary를 소요시간에 따라 내림차순 정렬
    let sortedTitleMaxDuration = maxDurationByTitle.sorted { $0.value > $1.value }

    // 정렬된 Dictionary를 새로운 Dictionary로 변환
    let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedTitleMaxDuration)

    return sortedDictionary
}

//func getWeeklyMaxTitleDuration(wiDList: [WiD], title: String, forDate date: Date) -> TimeInterval {
//    var durationsByDate: [Date: TimeInterval] = [:]
//    let calendar = Calendar.current
//
//    let startOfWeek: Date
//    let endOfWeek: Date
//
//    let weekday = calendar.component(.weekday, from: date)
//    if weekday == 1 {
//        startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
//        endOfWeek = date
//    } else {
//        startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
//        endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
//    }
//
//    var currentDate = startOfWeek
//    while currentDate <= endOfWeek {
//        let filteredWiDList = wiDList.filter { wiD in
//            return calendar.isDate(wiD.date, equalTo: currentDate, toGranularity: .day) && wiD.title == title
//        }
//
//        let totalDuration = filteredWiDList.reduce(0) { $0 + $1.duration }
//        durationsByDate[currentDate] = totalDuration
//
//        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
//            break
//        }
//        currentDate = nextDate
//    }
//
//    if let maxDuration = durationsByDate.values.max() {
//        return maxDuration
//    } else {
//        return 0
//    }
//}
//
//func getMonthlyMaxTitleDuration(wiDList: [WiD], title: String, forDate date: Date) -> TimeInterval {
//    var durationsByDate: [Date: TimeInterval] = [:]
//
//    let calendar = Calendar.current
//    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
//    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
//
//    var currentDate = startOfMonth
//    while currentDate <= endOfMonth {
//        let filteredWiDList = wiDList.filter { wiD in
//            return calendar.isDate(wiD.date, equalTo: currentDate, toGranularity: .day) && wiD.title == title
//        }
//
//        let totalDuration = filteredWiDList.reduce(0) { $0 + $1.duration }
//        durationsByDate[currentDate] = totalDuration
//
//        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
//            break
//        }
//        currentDate = nextDate
//    }
//
//    if let maxDuration = durationsByDate.values.max() {
//        return maxDuration
//    } else {
//        return 0
//    }
//}

//func getLongestStreak(wiDList: [WiD], title: String, startDate: Date, finishDate: Date) -> (start: Date, end: Date)? {
//    let calendar = Calendar.current
//
//    // Filter WiDs with the specified title and within the date range
//    let filteredWiDList = wiDList.filter { wiD in
////        return wiD.title == title && startDate <= wiD.date && wiD.date <= finishDate
//        return wiD.title == title && (calendar.isDate(wiD.date, inSameDayAs: startDate) || (startDate.compare(wiD.date) == .orderedAscending && finishDate.compare(wiD.date) == .orderedDescending) || calendar.isDate(wiD.date, inSameDayAs: finishDate))
//    }
//
//    // Sort WiDs by date, 파라미터의 wiDList가 날짜별로 오름차순 정렬되어 전달되기 때문에 따로 정렬할 필요가 없다.
////    let sortedWiDs = filteredWiDList.sorted { $0.date < $1.date }
//
//    // Find the longest continuous period
//    var currentPeriodStart: Date?
//    var currentPeriodEnd: Date?
//    var longestPeriodStart: Date?
//    var longestPeriodEnd: Date?
//
//    var previousWiD: WiD?
//
//    for wiD in filteredWiDList {
//        // Skip if the current WiD has the same date as the previous one
//        if let previousDate = previousWiD?.date, calendar.isDate(wiD.date, inSameDayAs: previousDate) {
//            continue
//        }
//
//        if let previousDate = currentPeriodEnd, calendar.isDate(wiD.date, equalTo: calendar.date(byAdding: .day, value: 1, to: previousDate)!, toGranularity: .day) {
//            // WiD date is consecutive, extend the current period
//            currentPeriodEnd = wiD.date
//        } else {
//            // WiD date is not consecutive, start a new period
//            currentPeriodStart = wiD.date
//            currentPeriodEnd = wiD.date
//        }
//
//        // Update the longest period if needed
//        if let longestStart = longestPeriodStart, let longestEnd = longestPeriodEnd {
//            let currentDuration = calendar.dateComponents([.day], from: currentPeriodStart!, to: currentPeriodEnd!).day ?? 0
//            let longestDuration = calendar.dateComponents([.day], from: longestStart, to: longestEnd).day ?? 0
//
//            if longestDuration <= currentDuration {
//                longestPeriodStart = currentPeriodStart
//                longestPeriodEnd = currentPeriodEnd
//            }
//        } else {
//            longestPeriodStart = currentPeriodStart
//            longestPeriodEnd = currentPeriodEnd
//        }
//
//        // Save the current WiD as the previous one for the next iteration
//        previousWiD = wiD
//    }
//
//    // Return the result if a longest period is found
//    if let start = longestPeriodStart, let end = longestPeriodEnd {
//        return (start, end)
//    } else {
//        return nil
//    }
//}
//
//func getCurrentStreak(wiDList: [WiD], title: String, startDate: Date, finishDate: Date) -> Date? {
//    let calendar = Calendar.current
//
//    // Filter WiDs with the specified title and within the date range
//    let filteredWiDList = wiDList.filter { wiD in
//        return wiD.title == title && (calendar.isDate(wiD.date, inSameDayAs: startDate) || (startDate.compare(wiD.date) == .orderedAscending && finishDate.compare(wiD.date) == .orderedDescending) || calendar.isDate(wiD.date, inSameDayAs: finishDate))
//    }
//
//    // Sort WiDs by date
//    let sortedWiDs = filteredWiDList.sorted { $0.date < $1.date }
//
//    // Find the start of the current streak
//    var currentStreakStart: Date?
//    var currentStreakEnd: Date?
//
//    for wiD in sortedWiDs {
//        if calendar.isDateInToday(wiD.date) {
//            // Today's WiD exists, continue backward to find the streak start
//            currentStreakEnd = wiD.date
//            while let previousDate = calendar.date(byAdding: .day, value: -1, to: currentStreakEnd!) {
//                let previousWiD = sortedWiDs.first { calendar.isDate($0.date, inSameDayAs: previousDate) }
//                if let previousWiD = previousWiD, calendar.isDateInToday(previousWiD.date) {
//                    // Continue backward until the streak breaks
//                    currentStreakEnd = previousWiD.date
//                } else {
//                    // Found the start of the streak
//                    currentStreakStart = previousDate
//                    break
//                }
//            }
//            break
//        }
//    }
//
//    return currentStreakStart
//}
