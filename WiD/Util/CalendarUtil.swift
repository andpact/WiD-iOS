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

func weekNumber(for date: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.weekOfYear], from: date)
    return components.weekOfYear ?? 1
}

func updateFirstDayOfWeek(for currentDate: Date) -> Date {
    let calendar = Calendar.current
    let weekday = calendar.component(.weekday, from: currentDate)
    let daysToSubtract = (weekday - 2 + 7) % 7
    
    guard let firstDayOfWeek = calendar.date(byAdding: .day, value: -daysToSubtract, to: currentDate) else {
        return currentDate
    }
    
    return firstDayOfWeek
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
