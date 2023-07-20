//
//  WiDReadMonthView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadMonthView: View {
    private let wiDService = WiDService()
    
    @State private var wiDs: [WiD] = []
    
    @State private var currentDate: Date = getFirstDayOfMonth(for: Date()) {
        didSet {
            let daysOfMonth = getDaysOfMonth(for: currentDate)

            var allWiDs: [WiD] = []

            // Loop through the dates for each day of the month
            for date in daysOfMonth {
                let wiDsForDate = wiDService.selectWiDsByDate(date: date)
                allWiDs.append(contentsOf: wiDsForDate)
            }

            wiDs = allWiDs
        }
    }
    
    private var totalDurationDictionary: [String: TimeInterval] {
        var result: [String: TimeInterval] = [:]

        for wiD in wiDs {
            if let currentDuration = result[wiD.title] {
                result[wiD.title] = currentDuration + wiD.duration
            } else {
                result[wiD.title] = wiD.duration
            }
        }

        return result
    }
    
    private var sortedTotalDurationDictionary: [(key: String, value: TimeInterval)] {
        totalDurationDictionary.sorted { $0.value > $1.value }
    }
    
    private var bestDurationDictionary: [String: TimeInterval] {
        var result: [String: TimeInterval] = [:]

        for wiD in wiDs {
            if let currentBestDuration = result[wiD.title] {
                if wiD.duration > currentBestDuration {
                    result[wiD.title] = wiD.duration

                }
            } else {
                result[wiD.title] = wiD.duration
            }
        }

        return result
    }
    
    private var bestDayDictionary: [String: Date] {
        var result: [String: Date] = [:]

        for wiD in wiDs {
            if result[wiD.title] != nil {
                if wiD.duration > (totalDurationDictionary[wiD.title] ?? 0) {
                    result[wiD.title] = wiD.date
                }
            } else {
                result[wiD.title] = wiD.date
            }
        }

        return result
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(formatDate(currentDate, format: "yyyy.MM"))
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    currentDate = getFirstDayOfMonth(for: Date())
                }) {
                    Text("현재")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDate(currentDate, equalTo: getFirstDayOfMonth(for: Date()), toGranularity: .month))

            }
            .border(Color.black)
            
            HStack(spacing: 0) {
                ForEach(0...6, id: \.self) { index in
                    let textColor = index == 0 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: .infinity)
            
            // 파이차트
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                let firstDayOfMonth = getFirstDayOfMonth(for: currentDate)
                let weekdayOffset = getWeekdayOffset(for: firstDayOfMonth)
                
                ForEach(0..<weekdayOffset, id: \.self) { _ in
                    // Empty chart for days before the first day of the month
                    PieChartView(data: [], date: firstDayOfMonth, isForOne: false)
                        .frame(width: 50, height: 50)
                }
                
                ForEach(getDaysOfMonth(for: currentDate), id: \.self) { day in
                    PieChartView(data: fetchChartData(date: day), date: day, isForOne: false)
                        .frame(width: 50, height: 50)
                }
            }
            .frame(maxWidth: .infinity)
            
            VStack {
                HStack {
                    Text("제목")
                        .frame(maxWidth: .infinity)
                    
                    Text("최고")
                        .frame(maxWidth: .infinity)
                    
                    Text("총합")
                        .frame(maxWidth: .infinity)
                }
                
                ForEach(sortedTotalDurationDictionary, id: \.key) { (title, totalDuration) in
                    if let bestDuration = bestDurationDictionary[title], let bestDay = bestDayDictionary[title] {
                        HStack {
                            Text(title)
                                .frame(maxWidth: .infinity)
                            
                            Text(formatDuration(bestDuration, isClickedWiD: false) + " (\(formatDate(bestDay, format: "d일")))")
                                .frame(maxWidth: .infinity)
                            
                            Text(formatDuration(totalDuration, isClickedWiD: false))
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .border(Color.black)
        .padding(.horizontal)
        .onAppear() {
            let daysOfMonth = getDaysOfMonth(for: currentDate)

            var allWiDs: [WiD] = []

            // Loop through the dates for each day of the month
            for date in daysOfMonth {
                let wiDsForDate = wiDService.selectWiDsByDate(date: date)
                allWiDs.append(contentsOf: wiDsForDate)
            }

            wiDs = allWiDs
        }
    }
}

struct WiDReadMonthView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadMonthView()
    }
}
