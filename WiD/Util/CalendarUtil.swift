//
//  DateTimeDurationUtil.swift
//  WiD
//
//  Created by jjkim on 2023/07/15.
//

import Foundation

func formatDate(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

// 해당 날짜의 요일 반환
func formatWeekday(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    return dateFormatter.string(from: date)
}

func formatWeekdayLetter(_ index: Int) -> String {
    let calendar = Calendar.current
    let weekdaySymbols = calendar.shortWeekdaySymbols
    let adjustedIndex = (index + calendar.firstWeekday - 1) % 7
    return weekdaySymbols[adjustedIndex]
}

// 해당 날짜가 올해의 몇 번째 주인지 반환
func weekNumber(for date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.weekOfYear], from: date)
    return components.weekOfYear ?? 1
}

// 해당 날짜가 속한 주의 첫 번째 날짜 반환
func getFirstDayOfWeek(for date: Date) -> Date {
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    let daysToSubtract = (weekday - 2 + 7) % 7
    
    guard let firstDayOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: date) else {
        return date
    }
    
    return firstDayOfWeek
}

// 해당 날짜가 속한 달의 첫 번째 날짜 반환
func getFirstDayOfMonth(for date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)
    guard let firstDayOfMonth = calendar.date(from: components) else {
        return date
    }
    return firstDayOfMonth
}

// 해당 날짜가 속한 달의 모든 날짜의 배열 반환
func getDaysOfMonthArray(for date: Date) -> [Date] {
    let calendar = Calendar.current
    let range = calendar.range(of: .day, in: .month, for: date)!
    let days = range.map { day -> Date in
        calendar.date(bySetting: .day, value: day, of: date)!
    }
    return days
}

// 해당 날짜가 속한 주에서 몇 번째 날짜인지 반환
func getWeekdayOffset(for date: Date) -> Int {
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: date)
    return (weekday + 6) % 7
}

func numberOfDaysInMonth(for date: Date) -> Int {
    let calendar = Calendar.current
    let monthRange = calendar.range(of: .day, in: .month, for: date)!
    return monthRange.count
}

func formatTime(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func formatDuration(_ interval: TimeInterval, isClickedWiD: Bool) -> String {
    let seconds = Int(interval) % 60
    let minutes = (Int(interval) / 60) % 60
    let hours = Int(interval) / (60 * 60)

    var formattedDuration = ""

    if isClickedWiD {
        if 0 < hours {
            if 0 == minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간", hours)
            } else if 0 < minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간 %d분", hours, minutes)
            } else if 0 < hours && 0 == minutes && 0 < seconds {
                formattedDuration = String(format: "%d시간 %d초", hours, seconds)
            } else {
                formattedDuration = String(format: "%d시간 %d분 %d초", hours, minutes, seconds)
            }
        } else if 0 < minutes {
            if 0 == seconds {
                formattedDuration = String(format: "%d분", minutes)
            } else {
                formattedDuration = String(format: "%d분 %d초", minutes, seconds)
            }
        } else {
            formattedDuration = String(format: "%d초", seconds)
        }
    } else {
        if 0 < hours {
            if 0 == minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간", hours)
            } else if 0 < minutes && 0 == seconds {
                formattedDuration = String(format: "%d시간 %d분", hours, minutes)
            } else if 0 < hours && 0 == minutes && 0 < seconds {
                formattedDuration = String(format: "%d시간 %d초", hours, seconds)
            } else {
                formattedDuration = String(format: "%d시간 %d분", hours, minutes)
            }
        } else if 0 < minutes {
            if 0 == seconds {
                formattedDuration = String(format: "%d분", minutes)
            } else {
                formattedDuration = String(format: "%d분 %d초", minutes, seconds)
            }
        } else {
            formattedDuration = String(format: "%d초", seconds)
        }
    }

    return formattedDuration
}
