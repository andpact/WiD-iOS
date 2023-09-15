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

func formatElapsedTime(_ time: Int) -> String {
    let hours = time / 3600
    let minutes = (time % 3600) / 60
    let seconds = time % 60

    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

func formatDuration(_ interval: TimeInterval, mode: Int) -> String {
    // mode 0. HH:mm:ss (10:30:30)
    // mode 1. H시간 (10.5시간), m분 (30.5분)
    // mode 2. H시간 m분 (10시간 30분)
    // mode 3. H시간 m분 s초 (10시간 30분 30초)
    
    let hours = Int(interval) / (60 * 60)
    let minutes = (Int(interval) / 60) % 60
    let seconds = Int(interval) % 60

    switch mode {
    case 0:
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)

    case 1:
        let totalHours = Double(hours) + (Double(minutes) / 60.0)
        let totalMinutes = Double(minutes) + (Double(seconds) / 60.0)

        if totalHours >= 1.1 {
            let formattedTotalHours = ((totalHours * 10).rounded() / 10).truncatingRemainder(dividingBy: 1.0) == 0.0 ?
                String(format: "%.0f", totalHours) :
                String(format: "%.1f", totalHours)
            return "\(formattedTotalHours)시간"
        } else if totalHours >= 1.0 {
            return "\(hours)시간"
        } else if totalMinutes >= 1.1 {
            let formattedTotalMinutes = ((totalMinutes * 10).rounded() / 10).truncatingRemainder(dividingBy: 1.0) == 0.0 ?
                String(format: "%.0f", totalMinutes) :
                String(format: "%.1f", totalMinutes)
            return "\(formattedTotalMinutes)분"
        } else if totalMinutes >= 1.0 {
            return "\(minutes)분"
        } else {
            return "\(seconds)초"
        }

    case 2:
        if hours > 0 && minutes == 0 && seconds == 0 {
            return String(format: "%d시간", hours)
        } else if hours > 0 && minutes > 0 && seconds == 0 {
            return String(format: "%d시간 %d분", hours, minutes)
        } else if hours > 0 && minutes == 0 && seconds > 0 {
            return String(format: "%d시간 %d초", hours, seconds)
        } else if hours > 0 {
            return String(format: "%d시간 %d분", hours, minutes)
        } else if minutes > 0 && seconds == 0 {
            return String(format: "%d분", minutes)
        } else if minutes > 0 {
            return String(format: "%d분 %d초", minutes, seconds)
        } else {
            return String(format: "%d초", seconds)
        }

    case 3:
        if hours > 0 && minutes == 0 && seconds == 0 {
            return String(format: "%d시간", hours)
        } else if hours > 0 && minutes > 0 && seconds == 0 {
            return String(format: "%d시간 %d분", hours, minutes)
        } else if hours > 0 && minutes == 0 && seconds > 0 {
            return String(format: "%d시간 %d초", hours, seconds)
        } else if hours > 0 {
            return String(format: "%d시간 %d분 %d초", hours, minutes, seconds)
        } else if minutes > 0 && seconds == 0 {
            return String(format: "%d분", minutes)
        } else if minutes > 0 {
            return String(format: "%d분 %d초", minutes, seconds)
        } else {
            return String(format: "%d초", seconds)
        }

    default:
        fatalError("Invalid mode value")
    }
}
