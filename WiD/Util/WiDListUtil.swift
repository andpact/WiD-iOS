//
//  WiDListUtil.swift
//  WiD
//
//  Created by jjkim on 2023/11/15.
//

import SwiftUI

func getDailyTotalDuration(wiDList: [WiD]) -> TimeInterval {
    let totalDuration = wiDList.reduce(0) { $0 + $1.duration }
    return totalDuration
}

func getDailyTotalDurationPercentage(wiDList: [WiD]) -> Int {
    let totalDuration = getDailyTotalDuration(wiDList: wiDList)
    let totalSecondsIn24Hours: TimeInterval = 24 * 60 * 60
    
    if totalSecondsIn24Hours > 0 {
        let percentage = Int((totalDuration / totalSecondsIn24Hours) * 100)
        return min(percentage, 100) // Ensure the percentage is within [0, 100] range
    } else {
        return 0
    }
}

func getDailyAllTitleDurationDictionary(wiDList: [WiD], forDate date: Date) -> [String: TimeInterval] {
    var titleTotalDuration: [String: TimeInterval] = [:]

    let filteredWiDList = wiDList.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }

    for wiD in filteredWiDList {
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

func getWeeklyAllTitleDurationDictionary(wiDList: [WiD], forDate date: Date) -> [String: TimeInterval] {
    var titleTotalDuration: [String: TimeInterval] = [:]

    let calendar = Calendar.current
    let startOfWeek: Date
    let endOfWeek: Date
    
    let weekday = calendar.component(.weekday, from: date)
    if weekday == 1 {
        startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
        endOfWeek = date
    } else {
        startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
        endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
    }

    for wiD in wiDList {
        if (startOfWeek...endOfWeek).contains(wiD.date) {
            if let existingDuration = titleTotalDuration[wiD.title] {
                titleTotalDuration[wiD.title] = existingDuration + wiD.duration
            } else {
                titleTotalDuration[wiD.title] = wiD.duration
            }
        }
    }

    // 정렬
    let sortedTitleTotalDuration = titleTotalDuration.sorted { $0.value > $1.value }
    return Dictionary(uniqueKeysWithValues: sortedTitleTotalDuration)
}

func getMonthlyAllTitleDurationDictionary(wiDList: [WiD], forDate date: Date) -> [String: TimeInterval] {
    var titleTotalDuration: [String: TimeInterval] = [:]

    let calendar = Calendar.current
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

    for wiD in wiDList {
        if (startOfMonth...endOfMonth).contains(wiD.date) {
            if let existingDuration = titleTotalDuration[wiD.title] {
                titleTotalDuration[wiD.title] = existingDuration + wiD.duration
            } else {
                titleTotalDuration[wiD.title] = wiD.duration
            }
        }
    }

    // Dictionary를 소요시간에 따라 내림차순 정렬
    let sortedTitleTotalDuration = titleTotalDuration.sorted { $0.value > $1.value }

    // 정렬된 Dictionary를 새로운 Dictionary로 변환
    let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedTitleTotalDuration)

    return sortedDictionary
}

func getWeeklyAverageTitleDuration(wiDList: [WiD], title: String, forDate date: Date) -> TimeInterval {
    var durationsByDate: [Date: TimeInterval] = [:]
    
    let calendar = Calendar.current
    let startOfWeek: Date
    let endOfWeek: Date
    
    let weekday = calendar.component(.weekday, from: date)
    if weekday == 1 {
        startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
        endOfWeek = date
    } else {
        startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
        endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
    }

    var currentDate = startOfWeek
    while currentDate <= endOfWeek {
        let filteredWiDList = wiDList.filter { wiD in
            return calendar.isDate(wiD.date, equalTo: currentDate, toGranularity: .day) && wiD.title == title
        }

        let totalDuration = filteredWiDList.reduce(0) { $0 + $1.duration }
        durationsByDate[currentDate] = totalDuration

        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
            break
        }
        currentDate = nextDate
    }

    let averageDurations = durationsByDate.values
    let totalDuration = averageDurations.reduce(0, +)
    let numberOfDays = Double(durationsByDate.count)
    
    return numberOfDays > 0 ? totalDuration / numberOfDays : 0
}

func getMonthlyAverageTitleDuration(wiDList: [WiD], title: String, forDate date: Date) -> TimeInterval {
    var durationsByDate: [Date: TimeInterval] = [:]
    
    let calendar = Calendar.current
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

    var currentDate = startOfMonth
    while currentDate <= endOfMonth {
        let filteredWiDList = wiDList.filter { wiD in
            return calendar.isDate(wiD.date, equalTo: currentDate, toGranularity: .day) && wiD.title == title
        }

        let totalDuration = filteredWiDList.reduce(0) { $0 + $1.duration }
        durationsByDate[currentDate] = totalDuration

        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
            break
        }
        currentDate = nextDate
    }

    let averageDurations = durationsByDate.values
    let totalDuration = averageDurations.reduce(0, +)
    let numberOfDays = Double(durationsByDate.count)
    
    return numberOfDays > 0 ? totalDuration / numberOfDays : 0
}

func getWeeklyMaxTitleDuration(wiDList: [WiD], title: String, forDate date: Date) -> TimeInterval {
    var durationsByDate: [Date: TimeInterval] = [:]
    let calendar = Calendar.current

    let startOfWeek: Date
    let endOfWeek: Date
    
    let weekday = calendar.component(.weekday, from: date)
    if weekday == 1 {
        startOfWeek = calendar.date(byAdding: .day, value: -6, to: date)!
        endOfWeek = date
    } else {
        startOfWeek = calendar.date(byAdding: .day, value: 2 - weekday, to: date)!
        endOfWeek = calendar.date(byAdding: .day, value: 8 - weekday, to: date)!
    }

    var currentDate = startOfWeek
    while currentDate <= endOfWeek {
        let filteredWiDList = wiDList.filter { wiD in
            return calendar.isDate(wiD.date, equalTo: currentDate, toGranularity: .day) && wiD.title == title
        }

        let totalDuration = filteredWiDList.reduce(0) { $0 + $1.duration }
        durationsByDate[currentDate] = totalDuration

        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
            break
        }
        currentDate = nextDate
    }

    if let maxDuration = durationsByDate.values.max() {
        return maxDuration
    } else {
        return 0
    }
}

func getMonthlyMaxTitleDuration(wiDList: [WiD], title: String, forDate date: Date) -> TimeInterval {
    var durationsByDate: [Date: TimeInterval] = [:]
    
    let calendar = Calendar.current
    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
    let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

    var currentDate = startOfMonth
    while currentDate <= endOfMonth {
        let filteredWiDList = wiDList.filter { wiD in
            return calendar.isDate(wiD.date, equalTo: currentDate, toGranularity: .day) && wiD.title == title
        }

        let totalDuration = filteredWiDList.reduce(0) { $0 + $1.duration }
        durationsByDate[currentDate] = totalDuration

        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
            break
        }
        currentDate = nextDate
    }

    if let maxDuration = durationsByDate.values.max() {
        return maxDuration
    } else {
        return 0
    }
}

func getLongestStreak(wiDList: [WiD], title: String, startDate: Date, finishDate: Date) -> (start: Date, end: Date)? {
    let calendar = Calendar.current

    // Filter WiDs with the specified title and within the date range
    let filteredWiDList = wiDList.filter { wiD in
//        return wiD.title == title && startDate <= wiD.date && wiD.date <= finishDate
        return wiD.title == title && (calendar.isDate(wiD.date, inSameDayAs: startDate) || (startDate.compare(wiD.date) == .orderedAscending && finishDate.compare(wiD.date) == .orderedDescending) || calendar.isDate(wiD.date, inSameDayAs: finishDate))
    }
    
    // Sort WiDs by date, 파라미터의 wiDList가 날짜별로 오름차순 정렬되어 전달되기 때문에 따로 정렬할 필요가 없다.
//    let sortedWiDs = filteredWiDList.sorted { $0.date < $1.date }

    // Find the longest continuous period
    var currentPeriodStart: Date?
    var currentPeriodEnd: Date?
    var longestPeriodStart: Date?
    var longestPeriodEnd: Date?

    var previousWiD: WiD?

    for wiD in filteredWiDList {
        // Skip if the current WiD has the same date as the previous one
        if let previousDate = previousWiD?.date, calendar.isDate(wiD.date, inSameDayAs: previousDate) {
            continue
        }

        if let previousDate = currentPeriodEnd, calendar.isDate(wiD.date, equalTo: calendar.date(byAdding: .day, value: 1, to: previousDate)!, toGranularity: .day) {
            // WiD date is consecutive, extend the current period
            currentPeriodEnd = wiD.date
        } else {
            // WiD date is not consecutive, start a new period
            currentPeriodStart = wiD.date
            currentPeriodEnd = wiD.date
        }

        // Update the longest period if needed
        if let longestStart = longestPeriodStart, let longestEnd = longestPeriodEnd {
            let currentDuration = calendar.dateComponents([.day], from: currentPeriodStart!, to: currentPeriodEnd!).day ?? 0
            let longestDuration = calendar.dateComponents([.day], from: longestStart, to: longestEnd).day ?? 0

            if longestDuration <= currentDuration {
                longestPeriodStart = currentPeriodStart
                longestPeriodEnd = currentPeriodEnd
            }
        } else {
            longestPeriodStart = currentPeriodStart
            longestPeriodEnd = currentPeriodEnd
        }

        // Save the current WiD as the previous one for the next iteration
        previousWiD = wiD
    }

    // Return the result if a longest period is found
    if let start = longestPeriodStart, let end = longestPeriodEnd {
        return (start, end)
    } else {
        return nil
    }
}

func getCurrentStreak(wiDList: [WiD], title: String, startDate: Date, finishDate: Date) -> Date? {
    let calendar = Calendar.current
    
    // Filter WiDs with the specified title and within the date range
    let filteredWiDList = wiDList.filter { wiD in
        return wiD.title == title && (calendar.isDate(wiD.date, inSameDayAs: startDate) || (startDate.compare(wiD.date) == .orderedAscending && finishDate.compare(wiD.date) == .orderedDescending) || calendar.isDate(wiD.date, inSameDayAs: finishDate))
    }
    
    // Sort WiDs by date
    let sortedWiDs = filteredWiDList.sorted { $0.date < $1.date }
    
    // Find the start of the current streak
    var currentStreakStart: Date?
    var currentStreakEnd: Date?
    
    for wiD in sortedWiDs {
        if calendar.isDateInToday(wiD.date) {
            // Today's WiD exists, continue backward to find the streak start
            currentStreakEnd = wiD.date
            while let previousDate = calendar.date(byAdding: .day, value: -1, to: currentStreakEnd!) {
                let previousWiD = sortedWiDs.first { calendar.isDate($0.date, inSameDayAs: previousDate) }
                if let previousWiD = previousWiD, calendar.isDateInToday(previousWiD.date) {
                    // Continue backward until the streak breaks
                    currentStreakEnd = previousWiD.date
                } else {
                    // Found the start of the streak
                    currentStreakStart = previousDate
                    break
                }
            }
            break
        }
    }
    
    return currentStreakStart
}
