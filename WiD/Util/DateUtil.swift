//
//  DateUtil.swift
//  WiD
//
//  Created by jjkim on 2023/12/01.
//

import SwiftUI
import Foundation

func formatDate(_ date: Date, format: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}

func getDayString(date: Date) -> some View {
    let calendar = Calendar.current
    
    return HStack {
        Text(formatDate(date, format: "yyyy년 M월 d일"))
        
        HStack(spacing: 0) {
            Text("(")

            Text(formatWeekday(date))
                .foregroundColor(calendar.component(.weekday, from: date) == 1 ? .red : (calendar.component(.weekday, from: date) == 7 ? .blue : .black))

            Text(")")
        }
    }
}

func getDayStringWith2Lines(date: Date) -> some View {
    let calendar = Calendar.current
    
    return VStack(alignment: .leading) {
        Text(formatDate(date, format: "yyyy년"))
        
        HStack {
            Text(formatDate(date, format: "M월 d일"))
            
            HStack(spacing: 0) {
                Text("(")

                Text(formatWeekday(date))
                    .foregroundColor(calendar.component(.weekday, from: date) == 1 ? .red : (calendar.component(.weekday, from: date) == 7 ? .blue : .black))

                Text(")")
            }
        }
    }
}

func getDayStringWith3Lines(date: Date) -> some View {
    let calendar = Calendar.current
    
    return VStack {
        Text(formatDate(date, format: "yyyy년"))
        
        Text(formatDate(date, format: "M월 d일"))
        
        HStack(spacing: 0) {
            Text(formatWeekday(date))
                .foregroundColor(calendar.component(.weekday, from: date) == 1 ? .red : (calendar.component(.weekday, from: date) == 7 ? .blue : .black))

            Text("요일")
        }
    }
}

func getWeekString(firstDayOfWeek: Date, lastDayOfWeek: Date) -> some View {
    let calendar = Calendar.current
    
    return HStack {
        Text(formatDate(firstDayOfWeek, format: "yyyy년 M월 d일"))
        
        HStack(spacing: 0) {
            Text("(")

            Text(formatWeekday(firstDayOfWeek))
                .foregroundColor(calendar.component(.weekday, from: firstDayOfWeek) == 1 ? .red : (calendar.component(.weekday, from: firstDayOfWeek) == 7 ? .blue : .black))

            Text(")")
        }
        
        Text("~")
        
        if !calendar.isDate(lastDayOfWeek, equalTo: firstDayOfWeek, toGranularity: .year) {
            Text(formatDate(lastDayOfWeek, format: "yyyy년 M월 d일"))
        } else if !calendar.isDate(firstDayOfWeek, equalTo: lastDayOfWeek, toGranularity: .month) {
            Text(formatDate(lastDayOfWeek, format: "M월 d일"))
        } else {
            Text(formatDate(lastDayOfWeek, format: "d일"))
        }
        
        HStack(spacing: 0) {
            Text("(")
            
            Text(formatWeekday(lastDayOfWeek))
                .foregroundColor(calendar.component(.weekday, from: lastDayOfWeek) == 1 ? .red : (calendar.component(.weekday, from: lastDayOfWeek) == 7 ? .blue : .black))
            
            Text(")")
        }
    }
}

func getMonthString(date: Date) -> some View {
    return Text(formatDate(date, format: "yyyy년 M월"))
}

// 해당 날짜의 요일 반환 (한국어)
func formatWeekday(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 로케일로 설정
    return dateFormatter.string(from: date)
}

func formatWeekdayLetterFromSunday(_ index: Int) -> String {
    let weekdays = ["일", "월", "화", "수", "목", "금", "토"]
    let adjustedIndex = (index + Calendar.current.firstWeekday - 1) % 7
    return weekdays[adjustedIndex]
}

func formatWeekdayLetterFromMonday(_ index: Int) -> String {
    let weekdays = ["월", "화", "수", "목", "금", "토", "일"]
    let adjustedIndex = (index + Calendar.current.firstWeekday - 1) % 7
    return weekdays[adjustedIndex]
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

// 해당 날짜가 속한 주의 마지막 날짜 반환
func getLastDayOfWeek(for date: Date) -> Date {
    let calendar = Calendar.current
    let firstDayOfWeek = getFirstDayOfWeek(for: date)
    
    guard let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: firstDayOfWeek) else {
        return date
    }
    
    return lastDayOfWeek
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

// 해당 날짜가 속한 달의 마지막 날짜 반환
func getLastDayOfMonth(for date: Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date)

    // 해당 달의 다음 달의 첫 번째 날짜에서 하루 전으로 이동하여 현재 달의 마지막 날짜를 얻습니다.
    guard let firstDayOfNextMonth = calendar.date(from: DateComponents(year: components.year, month: components.month! + 1, day: 1)),
          let lastDayOfMonth = calendar.date(byAdding: .day, value: -1, to: firstDayOfNextMonth) else {
        return date
    }

    return lastDayOfMonth
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
