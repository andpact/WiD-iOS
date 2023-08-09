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
            let daysOfMonthArray = getDaysOfMonthArray(for: currentDate)

            var allWiDs: [WiD] = []

            // Loop through the dates for each day of the month
            for date in daysOfMonthArray {
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
                Text("WiD")
                    .font(.custom("Acme-Regular", size: 20))
                    .padding(.horizontal, 8)
                    .foregroundColor(.white)
                    .background(.black)
                    .cornerRadius(5)
                    .padding(.horizontal, 8)
                
                Text(formatDate(currentDate, format: "yyyy년 M월"))
                    .frame(maxWidth: .infinity)
                
                Button(action: {
                    withAnimation {
                        currentDate = getFirstDayOfMonth(for: Date())
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                }
                .padding(.horizontal, 8)
                .disabled(Calendar.current.isDate(currentDate, equalTo: getFirstDayOfMonth(for: Date()), toGranularity: .month))
                
                Button(action: {
                    withAnimation {
                        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding(.horizontal, 8)
                
                Button(action: {
                    withAnimation {
                        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                }
                .padding(.horizontal, 8)
                .disabled(Calendar.current.isDate(currentDate, equalTo: getFirstDayOfMonth(for: Date()), toGranularity: .month))
            }
            .padding(.bottom, 8)
            
            // 요일 표시
            HStack {
                ForEach(0...6, id: \.self) { index in
                    let textColor = index == 0 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            
            // 파이 차트 표시
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 0) {
                let firstDayOfMonth = getFirstDayOfMonth(for: currentDate)
                let weekdayOffset = getWeekdayOffset(for: firstDayOfMonth)

                ForEach(0..<weekdayOffset, id: \.self) { _ in
                    PieChartView(data: [], date: firstDayOfMonth, isForOne: false, isEmpty: true)
                }

                ForEach(getDaysOfMonthArray(for: currentDate), id: \.self) { day in
                    PieChartView(data: fetchChartData(date: day), date: day, isForOne: false, isEmpty: false)
                }
            }
            .padding(.bottom, 8)

            // 제목 별 총합 표시
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color("light_gray"))
                        .frame(width: 7, height: 20)
                    
                    Text("제목")
                        .frame(width: 70)
                    
                    Text("최고")
                        .frame(maxWidth: .infinity)
                    
                    Text("총합")
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .background(Color("light_gray"))
                .cornerRadius(5)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                if sortedTotalDurationDictionary.isEmpty {
                    Spacer()
                    Text("표시할 데이터가 없습니다.")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                } else {
                    ScrollView {
                        ForEach(sortedTotalDurationDictionary, id: \.key) { (title, totalDuration) in
                            if let bestDuration = bestDurationDictionary[title], let bestDay = bestDayDictionary[title] {
                                
//                                let totalDurationOfWeek = 60 * 60 * 24 * 7
//                                let bestDurationPercentage = (Double(bestDuration) / Double(totalDurationOfWeek)) * 100
//                                let totalDurationPercentage = (Double(totalDuration) / Double(totalDurationOfWeek)) * 100
                                
                                HStack {
                                    Rectangle()
                                        .fill(Color(title))
                                        .frame(width: 7, height: 20)

                                    Text(titleDictionary[title] ?? "")
                                        .frame(width: 70)
                                    
//                                    Text("\(formatDate(bestDay, format: "d일")) / " + formatDuration(bestDuration, isClickedWiD: false) + " " +  String(format: "(%.1f%)", bestDurationPercentage))
                                    Text(formatDuration(bestDuration, isClickedWiD: false) + "(\(formatDate(bestDay, format: "d일")))")
                                        .frame(maxWidth: .infinity)
                                    
//                                    Text(formatDuration(totalDuration, isClickedWiD: false) + " " + String(format: "(%.1f%)", totalDurationPercentage))
                                    
                                    Text(formatDuration(totalDuration, isClickedWiD: false))
                                        .frame(maxWidth: .infinity)
                                }
                                .frame(maxWidth: .infinity)
                                .background(Color("light_gray"))
                                .cornerRadius(5)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onAppear() {
            let daysOfMonth = getDaysOfMonthArray(for: currentDate)

            var allWiDs: [WiD] = []

            // Loop through the dates for each day of the month
            for date in daysOfMonth {
                let wiDsForDate = wiDService.selectWiDsByDate(date: date)
                allWiDs.append(contentsOf: wiDsForDate)
            }

            withAnimation {
                wiDs = allWiDs
            }
        }
    }
}

struct WiDReadMonthView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadMonthView()
    }
}
