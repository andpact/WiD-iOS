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
            // 날짜 표시
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
                .padding(.horizontal)
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDate(currentDate, equalTo: getFirstDayOfMonth(for: Date()), toGranularity: .month))

            }
            
            // 요일 표시
            HStack(spacing: 0) {
                ForEach(0...6, id: \.self) { index in
                    let textColor = index == 0 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            .padding(.top)
            
            // 파이 차트 표시
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                let firstDayOfMonth = getFirstDayOfMonth(for: currentDate)
                let weekdayOffset = getWeekdayOffset(for: firstDayOfMonth)
                
                ForEach(0..<weekdayOffset, id: \.self) { _ in
                    PieChartView(data: [], date: firstDayOfMonth, isForOne: false)
                }
                
                ForEach(getDaysOfMonth(for: currentDate), id: \.self) { day in
                    PieChartView(data: fetchChartData(date: day), date: day, isForOne: false)
                        .frame(width: 50, height: 50)
                }
            }
            .frame(maxWidth: .infinity)
            
            // 제목 별 총합 표시
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color("light_gray"))
                        .frame(width: 10, height: 20)
                    
                    Text("제목")
                    
                    Text("최고")
                    
                    Text("총합")
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                ForEach(sortedTotalDurationDictionary, id: \.key) { (title, totalDuration) in
                    if let bestDuration = bestDurationDictionary[title], let bestDay = bestDayDictionary[title] {
                        HStack {
                            Rectangle()
                                .fill(Color(title))
                                .frame(width: 10, height: 20)
                            
                            Text(titleDictionary[title] ?? "")
                            
                            Text(formatDuration(bestDuration, isClickedWiD: false) + " (\(formatDate(bestDay, format: "d일")))")
                            
                            Text(formatDuration(totalDuration, isClickedWiD: false))
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("light_gray"))
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                }
                Spacer()
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
