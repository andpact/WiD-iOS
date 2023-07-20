//
//  WiDReadWeekView.swift
//  WiD
//
//  Created by jjkim on 2023/07/14.
//

import SwiftUI

struct WiDReadWeekView: View {
    private let wiDService = WiDService()
    
    @State private var wiDs: [WiD] = []
    
    @State private var currentDate: Date = getFirstDayOfWeek(for: Date()) {
        didSet {
            var allWiDs: [WiD] = []
            
            // Loop through the dates for each day of the week
            for index in 0..<7 {
                let date = Calendar.current.date(byAdding: .day, value: index, to: currentDate) ?? currentDate
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
                HStack {
                    Text(formatDate(currentDate, format: "yyyy년"))
                        
                    Text("\(weekNumber(for: currentDate))번째 주")
                }
                .frame(maxWidth: .infinity)

                Button(action: {
                    currentDate = getFirstDayOfWeek(for: Date())
                }) {
                    Text("현재")
                }
                
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                }

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                }
                .disabled(Calendar.current.isDate(currentDate, equalTo: getFirstDayOfWeek(for: Date()), toGranularity: .weekOfYear))
            }
            .border(Color.black)
            
            HStack(spacing: 0) {
                ForEach(1...7, id: \.self) { index in
                    let textColor = index == 7 ? Color.red : (index == 6 ? Color.blue : Color.black)
                    
                    Text(formatWeekdayLetter(index))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(textColor)
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack(spacing: 0) {
                ForEach(0..<7) { index in
                    PieChartView(data: fetchChartData(date: Calendar.current.date(byAdding: .day, value: index, to: currentDate) ?? currentDate), date: Calendar.current.date(byAdding: .day, value: index, to: currentDate) ?? currentDate, isForOne: false)
                }
            }
            .frame(maxWidth: .infinity)
            .border(Color.red)
            
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
        .frame(maxWidth: .infinity)
        .border(Color.black)
        .padding(.horizontal)
        .onAppear() {
            var allWiDs: [WiD] = []
            
            // Loop through the dates for each day of the week
            for index in 0..<7 {
                let date = Calendar.current.date(byAdding: .day, value: index, to: currentDate) ?? currentDate
                let wiDsForDate = wiDService.selectWiDsByDate(date: date)
                allWiDs.append(contentsOf: wiDsForDate)
            }
            
            wiDs = allWiDs
        }
    }
}

struct WiDReadWeekView_Previews: PreviewProvider {
    static var previews: some View {
        WiDReadWeekView()
    }
}
